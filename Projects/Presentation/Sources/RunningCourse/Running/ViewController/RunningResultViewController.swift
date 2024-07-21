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
        return RunningResultView()
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
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteAction))
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

        let region = MKCoordinateRegion(
            center: coordinates[0],
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        runningResultView.mapArea.mapView.delegate = self
        runningResultView.mapArea.mapView.setRegion(region, animated: true)
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        coordinator?.finishRunning()
    }
    
    @objc func deleteAction() {
    }
    
    private func initData() {
        
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
        
        Observable<[Double: RouteInfo]>.just(calculateTotalRunningTimePerKm())
            .bind(to: runningResultView.recordView.tableView.rx.items(cellIdentifier: RunningResultRecordTableViewCell.identifier, cellType: RunningResultRecordTableViewCell.self)) { index, model, cell in
                cell.setData(distance: model.key, time: Int(model.value.runningTime))
                
                // 마지막줄 라인 제거
                if index == 4 {
                    cell.removeLine()
                }
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
                print("isSaveCompleted -> finish")
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
            .map { Reactor.Action.tapDifficultyButton(1) }

        let difficulty2Tap = runningResultView.difficultyArea.difficulty2Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(2) }
        
        let difficulty3Tap = runningResultView.difficultyArea.difficulty3Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(3) }
        
        let difficulty4Tap = runningResultView.difficultyArea.difficulty4Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(4) }
        
        let difficulty5Tap = runningResultView.difficultyArea.difficulty5Button.rx.tap
            .map { Reactor.Action.tapDifficultyButton(5) }

        Observable.merge(difficulty1Tap, difficulty2Tap, difficulty3Tap, difficulty4Tap, difficulty5Tap)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.difficultyLevel}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] level in
                guard let self = self else { return }
                runningResultView.difficultyArea.setDifficulty(level: level)
            }.disposed(by: self.disposeBag)
    }
    
    //MARK: - Helpers
    
    func calculateTotalRunningTimePerKm() -> [Double: RouteInfo] {
        let groupedByDistance = Dictionary(grouping: runningResult.routeList) { Int($0.distance) }
        var routeInfoPerKm: [Double: RouteInfo] = [:]
        
        for (km, values) in groupedByDistance {
            if let routeInfo = values.max(by: { $0.timestamp < $1.timestamp }) {
                routeInfoPerKm[Double(km)] = routeInfo
            }
        }
        return routeInfoPerKm
    }
}

// MARK: - Map Extension

extension RunningResultViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3

            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
