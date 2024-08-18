//
//  RunningResultViewController.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import RxRelay
import RxDataSources
import Domain
import MapKit

final public class RunningResultViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RunningCoordinatorInterface?
    
    public var runningResult = RunningResult()
    
    public var disposeBag = DisposeBag()
    
    private var runningResultView: RunningResultView = {
        return RunningResultView(isRunningResult: true)
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RunningResultReactor, runningResult: RunningResult){
        super.init(nibName: nil, bundle: nil)
        
        self.runningResult = runningResult
        self.reactor = reactor
    }
    
    deinit {
        print("deinit RunningResultViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
        configureMap()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Configure
    
    private func configureNavigationBar() {
        self.title = "러닝 기록"
        self.navigationController?.navigationBar.tintColor = .black
        
        // Back Button 없애기로 의사결정됨
        self.navigationItem.setHidesBackButton(true, animated: true)
//        let backButton: UIButton = UIButton(type: .custom)
//        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
//        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteAction))
        self.navigationItem.rightBarButtonItem?.tintColor = .Neutrals300
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(runningResultView)
        
        runningResultView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureMap() {
        let coordinates = runningResult.routeList.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        runningResultView.mapArea.mapView.addOverlay(polyline)

        // 경로의 최대/최소 좌표를 계산
        var minLat = runningResult.routeList[0].latitude
        var maxLat = runningResult.routeList[0].latitude
        var minLon = runningResult.routeList[0].longitude
        var maxLon = runningResult.routeList[0].longitude

        for coordinate in runningResult.routeList {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }

        // 중심 좌표와 span(확대/축소 정도)를 계산
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.2, // 여유를 주기 위해 1.2배
            longitudeDelta: (maxLon - minLon) * 1.2 // 여유를 주기 위해 1.2배
        )
        let region = MKCoordinateRegion(center: center, span: span)
        
        runningResultView.mapArea.mapView.delegate = self
        runningResultView.mapArea.mapView.setRegion(region, animated: true)
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        coordinator?.finishRunning()
    }
    
    @objc func deleteAction() {
        let requestLocationServiceAlert = UIAlertController(
            title: "기록 삭제",
            message: "삭제된 기록은 다시 불러올 수 없습니다.\n해당 기록을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.coordinator?.finishRunning()
        }
        let cancel = UIAlertAction(title: "아니오", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(confirm)
        
        self.present(requestLocationServiceAlert, animated: true)
    }
}

// MARK: - Binding

extension RunningResultViewController: View {
    
    public func bind(reactor: RunningResultReactor) {
        bindingView(reactor: reactor)
        bindingState(reactor: reactor)
        bindingButtonAction(reactor: reactor)
        bindingDifficultyButtonAction(reactor: reactor)
    }
    
    private func bindingView(reactor: RunningResultReactor) {
        
        Observable.just(true)
            .bind { [weak self] _ in
                guard let self = self else {return}
                self.runningResultView.setData(runningModel: runningResult)
            }
            .disposed(by: disposeBag)
        
        Observable<Array<(key: Double, value: RouteInfo)>>.just(calculateTotalRunningTimePerKm())
            .bind(to: runningResultView.recordView.tableView.rx.items(cellIdentifier: RunningResultRecordTableViewCell.identifier, cellType: RunningResultRecordTableViewCell.self)) { index, model, cell in
                cell.setData(distance: model.key, time: Int(model.value.runningTime))
            }
            .disposed(by: disposeBag)
        
        self.runningResultView.recordView.tableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.runningResultView.recordView.tableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingState(reactor: RunningResultReactor) {
        reactor.state
            .map{$0.isSaveCompleted}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] level in
                guard let self = self else { return }
                coordinator?.finishRunning()
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingButtonAction(reactor: RunningResultReactor) {
        runningResultView.saveButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                reactor.action.onNext(.saveRunningRecord(runningResult))
            }
            .disposed(by: disposeBag)
    }
    
    private func bindingDifficultyButtonAction(reactor: RunningResultReactor) {
        let difficulty1Tap = runningResultView.difficultyArea.difficulty1Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(.VERYEASY) }

        let difficulty2Tap = runningResultView.difficultyArea.difficulty2Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(.EASY) }
        
        let difficulty3Tap = runningResultView.difficultyArea.difficulty3Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(.NORMAL) }
        
        let difficulty4Tap = runningResultView.difficultyArea.difficulty4Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(.HARD) }
        
        let difficulty5Tap = runningResultView.difficultyArea.difficulty5Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(.VERYHARD) }

        Observable.merge(difficulty1Tap, difficulty2Tap, difficulty3Tap, difficulty4Tap, difficulty5Tap)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.difficultyType}
            .distinctUntilChanged()
            .bind{ [weak self] difficulty in
                guard let self = self else { return }
                runningResult.difficulty = difficulty
                runningResultView.difficultyArea.setDifficulty(level: difficulty.level)
            }.disposed(by: self.disposeBag)
    }
    
    //MARK: - Helpers
    
    func calculateTotalRunningTimePerKm() -> Array<(key: Double, value: RouteInfo)> {
        let groupedByDistance = Dictionary(grouping: runningResult.routeList) { Int($0.distance) }
        var routeInfoPerKm: [Double: RouteInfo] = [:]
        
        for (km, values) in groupedByDistance {
            if let routeInfo = values.max(by: { $0.timestamp < $1.timestamp }) {
                routeInfoPerKm[Double(km)] = routeInfo
            }
        }
        
        let routes = routeInfoPerKm.sorted { $0.key < $1.key }
        runningResult.sectionPace = routes.map{ Int.convertTimeAndDistanceToPace(time: $0.value.runningTime, distance: $0.value.distance) }
        runningResult.sectionKcal = routes.map{ Int.convertTimeToCalorie(time: $0.value.runningTime) }
        return routes
    }
}

// MARK: - Map Extension

extension RunningResultViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor(hexaRGB: "2A71DB")
            renderer.lineWidth = 2

            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
