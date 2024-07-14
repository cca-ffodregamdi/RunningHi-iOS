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

final public class RunningViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RunningCoordinatorInterface?
    
    public var disposeBag = DisposeBag()
    
    private var routInfos: [RouteInfo] = []
    private var distance: Double = 0
    
    private lazy var runningView: RunningView = {
        return RunningView()
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RunningReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    deinit {
        print("deinit RunningCourseViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .BaseWhite
        self.view.addSubview(runningView)
        
        runningView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RunningViewController: View{
    
    public func bind(reactor: RunningReactor) {
        bindingReadyView(reactor: reactor)
        bindingRecordUpdateView(reactor: reactor)
        bindingButtonEvent(reactor: reactor)
    }
    
    // MARK: - Binding
    
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
                    showRequestLocationServiceAlert()
                }
            }.disposed(by: self.disposeBag)
        
        // Ready Timer CountDown Event
        reactor.state
            .map{$0.readyTime}
            .distinctUntilChanged()
            .bind{ [weak self] time in
                guard let self = self else { return }
                
                if time == 0 {
                    self.runningView.runningRecordView.toggleRunningState(isRunning: true)
//                    self.runningView.runningRecordView.setRunningData()
                    reactor.action.onNext(.startRunning)
                }
                self.runningView.setReadyView(time: time)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingRecordUpdateView(reactor: RunningReactor) {
        
        // Running State Change Event
        reactor.state
            .map{$0.isRunning}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] isRunning in
                guard let self = self else { return }
                self.runningView.runningRecordView.toggleRunningState(isRunning: isRunning)
            }.disposed(by: self.disposeBag)
        
        // Running Time Change Event
        reactor.state
            .map{$0.runningTime}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] time in
                guard let self = self else { return }
                self.runningView.runningRecordView.setRunningData(time: time)
            }.disposed(by: self.disposeBag)
        
        // Running Location Change Event
        reactor.state
            .map{$0.currentLocation}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] location in
                guard let self = self, let location = location, let before = routInfos.last else { return }
                routInfos.append(location)
                
                distance += haversineDistance(from: before, to: location)
                self.runningView.runningRecordView.setRunningData(distance: Int(distance))
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingButtonEvent(reactor: RunningReactor) {
        
        // Pause Button Tap Event
        runningView.runningRecordView.pauseButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
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
            .bind { [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.stopRunning)
                self.coordinator?.showRunningResult()
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
