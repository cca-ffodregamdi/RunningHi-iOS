//
//  RecordDetailViewController.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//
    
import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import RxRelay
import RxDataSources
import Domain
import MapKit
import Common

final public class RecordDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RecordCoordinatorInterface?
    
    public var postNo: Int?
    
    public var disposeBag = DisposeBag()
    
    private var runningResultView: RunningResultView = {
        return RunningResultView(isRunningResult: false)
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RecordDetailReactor, postNo: Int){
        super.init(nibName: nil, bundle: nil)
        
        self.postNo = postNo
        self.reactor = reactor
    }
    
    deinit {
        print("deinit RecordDetailViewController")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureNavigationBar() {
        self.title = "러닝 기록"
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let shareButton = UIButton()
        shareButton.setImage(CommonAsset.shareOutline.image, for: .normal)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.setImage(CommonAsset.trashOutline.image, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        let stackView = UIStackView.init(arrangedSubviews: [shareButton, deleteButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(runningResultView)
        
        runningResultView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareAction() {
        //TODO: 공유하기 기능 구현
    }
    
    @objc func deleteAction() {
        let requestLocationServiceAlert = UIAlertController(
            title: "기록 삭제",
            message: "삭제된 기록은 다시 불러올 수 없습니다.\n해당 기록을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if let reactor = self.reactor, let postNo = self.postNo {
                reactor.action.onNext(.deleteRunningRecord(postNo))
            }
        }
        let cancel = UIAlertAction(title: "아니오", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(confirm)
        
        self.present(requestLocationServiceAlert, animated: true)
    }
}

// MARK: - Binding

extension RecordDetailViewController: View {
    
    public func bind(reactor: RecordDetailReactor) {
        bindingView(reactor: reactor)
    }
    
    private func bindingView(reactor: RecordDetailReactor) {
        
        rx.viewDidLoad
            .bind { [weak self] _ in
                guard let self = self, let postNo = postNo else {return}
                reactor.action.onNext(.fetchRecordDetailData(postNo))
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap{$0.runningResult}
            .bind{ [weak self] runningResult in
                guard let self = self else { return }
                self.runningResultView.setData(runningModel: runningResult)
                self.configureMap(runningResult: runningResult)
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .compactMap {$0.runningResult}
            .map { self.calculateTotalRunningTimePerKm(runningResult: $0) }
            .bind(to: runningResultView.recordView.tableView.rx.items(cellIdentifier: RunningResultRecordTableViewCell.identifier, cellType: RunningResultRecordTableViewCell.self)) { index, model, cell in
                cell.setData(distance: model.key, time: Int(model.value.runningTime))
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .filter {$0.isFinishDeleteRunningRecord}
            .bind{ [weak self] runningResult in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
        
        self.runningResultView.recordView.tableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.runningResultView.recordView.tableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
    }
    
    //MARK: - Helpers
    
    func calculateTotalRunningTimePerKm(runningResult: RunningResult) -> Array<(key: Double, value: RouteInfo)> {
        let groupedByDistance = Dictionary(grouping: runningResult.routeList) { Int($0.distance) }
        var routeInfoPerKm: [Double: RouteInfo] = [:]

        for (km, values) in groupedByDistance {
            if let routeInfo = values.max(by: { $0.timestamp < $1.timestamp }) {
                routeInfoPerKm[Double(km)] = routeInfo
            }
        }

        let routes = routeInfoPerKm.sorted { $0.key < $1.key }
        return routes
    }
    
    private func configureMap(runningResult: RunningResult) {
        let coordinates = runningResult.routeList.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        runningResultView.mapArea.mapView.addOverlay(polyline)
        
        if runningResult.routeList.count == 0 { return }

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
}

// MARK: - Map Extension

extension RecordDetailViewController: MKMapViewDelegate {
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
