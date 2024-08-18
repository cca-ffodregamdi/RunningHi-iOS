//
//  RunningViewController.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay
import Domain
import CoreLocation

final public class RunningViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RunningCoordinatorInterface?
    
    private var runningResult = RunningResult()
    private var beforeLocation: RouteInfo?
    
    private var settingType: RunningSettingType?
    private var settingValue: Int = 0
    
    public var disposeBag = DisposeBag()
    
    private lazy var runningView: RunningView = {
        return RunningView()
    }()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RunningReactor, settingType: RunningSettingType?, value: Int = 0){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.settingType = settingType
        self.settingValue = value
        
        self.runningView.runningRecordView.showProgressView(settingType != nil)
    }
    
    deinit {
        print("deinit RunningViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotification()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .BaseWhite
        self.view.addSubview(runningView)
        
        runningView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func configureNotification() {
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let reactor = self.reactor else { return }
                reactor.action.onNext(.didEnterBackground)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let reactor = self.reactor else { return }
                reactor.action.onNext(.didEnterForeground)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Binding

extension RunningViewController: View {
    
    public func bind(reactor: RunningReactor) {
        bindingReadyView(reactor: reactor)
        bindingRecordView(reactor: reactor)
        bindingButtonEvent(reactor: reactor)
    }
    
    private func bindingReadyView(reactor: RunningReactor) {
        
        // 위치 권한 허용 여부 체크
        Observable.just(Reactor.Action.checkAuthorization)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 권한 체크 후 로직 실행
        reactor.state
            .map{$0.authorization}
            .distinctUntilChanged()
            .bind{ [weak self] status in
                guard let self = self, let status = status else { return }
                if status == .allowed {
                    reactor.action.onNext(.readyForRunning)
                } else {
                    self.showRequestLocationServiceAlert()
                }
            }.disposed(by: self.disposeBag)
        
        // 타이머 3초 카운트다운
        reactor.state
            .map{$0.readyTime}
            .distinctUntilChanged()
            .bind{ [weak self] time in
                guard let self = self else { return }
                if time == 0 {
                    self.runningResult.startTime = Date()
                    self.runningView.runningRecordView.toggleRunningState(isRunning: true)
                    
                    reactor.action.onNext(.startRunning)
                }
                self.runningView.setReadyView(time: time)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingRecordView(reactor: RunningReactor) {
        
        // 러닝 상태 변화 감지
        reactor.state
            .map{$0.isRunning}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] isRunning in
                guard let self = self else { return }
                self.runningView.runningRecordView.toggleRunningState(isRunning: isRunning)
            }.disposed(by: self.disposeBag)
        
        // 러닝 시간 1초마다 카운트업
        reactor.state
            .map{$0.runningTime}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] time in
                guard let self = self else { return }
                let calorie = Int.convertTimeToCalorie(time: time)
                self.runningResult.calorie = calorie
                self.runningView.runningRecordView.setRunningData(time: time, calorie: calorie)
                
                if settingType == .time && settingValue != 0 {
                    runningView.runningRecordView.setProgress(min(1.0, Float(time) / Float(settingValue)))
                }
            }.disposed(by: self.disposeBag)
        
        // 러닝 위치 변경 감지
        reactor.state
            .map{$0.currentLocation}
            .distinctUntilChanged()
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .skip(1)
            .withLatestFrom(reactor.state.map { $0.runningTime }) { ($0, $1) }
            .bind{ [weak self] (location, runningTime) in
                guard let self = self, var location = location else { return }
                
                var distance = self.runningResult.distance
                if let before = beforeLocation {
                    distance += haversineDistance(from: before, to: location)
                }
                
                print(location)
                
                location.distance = distance
                location.runningTime = runningTime
                self.runningResult.routeList.append(location)
                self.runningResult.distance = distance
                self.beforeLocation = location
                
                let pace: Int = (distance == 0.0) ? 0 : Int.convertTimeAndDistanceToPace(time: runningTime, distance: distance)
                self.runningResult.averagePace = pace
                self.runningView.runningRecordView.setRunningData(distance: distance, pace: pace)
                
                if settingType == .distance && settingValue != 0 {
                    runningView.runningRecordView.setProgress(min(1.0, Float(distance) / Float(settingValue)))
                }
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .compactMap{$0.currentLocation}
            .take(1)
            .bind{ [weak self] location in
                guard let self = self else { return }
                
                // 시작점 위치로 지역 저장하기
                let startLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(startLocation) { (placemarks, error) in
                    if let _ = error {
                        return
                    }
                    
                    if let placemark = placemarks?.first {
                        let locality = placemark.locality // ex 서울특별시
                        let subLocality = placemark.subLocality // ex 구로동
                        self.runningResult.location = subLocality ?? (locality ?? "")
                    }
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingButtonEvent(reactor: RunningReactor) {
        
        // Pause Button Tap Event
        runningView.runningRecordView.pauseButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.beforeLocation = nil
                reactor.action.onNext(.pauseRunning)
            }.disposed(by: self.disposeBag)
        
        // Play Button Tap Event
        runningView.runningRecordView.playButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
                reactor.action.onNext(.startRunning)
            }.disposed(by: self.disposeBag)
        
        // Stop Button Tap Event
        runningView.runningRecordView.stopButton.rx.tap
            .bind { [weak self] _ in
                guard let _ = self else { return }
                //TODO: 토스트 메시지 출력 (오늘의 운동을 중지하시려면 길게 눌러주세요)
            }
            .disposed(by: disposeBag)
        
        // Stop Button Long Tap Event
        runningView.runningRecordView.stopButtonlongPressGesture.rx.event
            .filter { $0.state == .began }
            .withLatestFrom(reactor.state.map { $0.runningTime }) { ($0, $1) }
            .bind { [weak self] (_, runningTime) in
                guard let self = self else { return }
                self.runningResult.endTime = Date()
                self.runningResult.runningTime = runningTime
                
                reactor.action.onNext(.stopRunning)
                self.coordinator?.showRunningResult(runningResult: runningResult)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    
    private func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 - 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
            
            self.navigationController?.popViewController(animated: false)
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        self.present(requestLocationServiceAlert, animated: true)
    }
    
    func haversineDistance(from: RouteInfo, to: RouteInfo) -> Double {
        let radiusOfEarth: Double = 6371.0 // 지구의 반경 (킬로미터)

        let lat1 = from.latitude * .pi / 180
        let lon1 = from.longitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let lon2 = to.longitude * .pi / 180

        let dlat = lat2 - lat1
        let dlon = lon2 - lon1

        let a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return radiusOfEarth * c
    }
}
