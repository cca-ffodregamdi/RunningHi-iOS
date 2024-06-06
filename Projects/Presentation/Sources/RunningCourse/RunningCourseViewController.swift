//
//  RunningCourseViewController.swift
//  Presentation
//
//  Created by 오영석 on 5/8/24.
//

import UIKit
import MapKit
import RxSwift
import ReactorKit
import RxRelay

protocol RunningCourseViewControllerDelegate {
    func didFinishCourse()
}

final class RunningCourseViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    var delegate: RunningCourseViewControllerDelegate?
    var reactor: RunningCourseReactor? {
        didSet {
            if let reactor = reactor {
                bind(reactor: reactor)
            }
        }
    }
    private lazy var runningCourseView: RunningCourseView = {
        return RunningCourseView()
    }()
    private var polyline: MKPolyline?
    private var startAnnotation: MKPointAnnotation?
    private var stopAnnotation: MKPointAnnotation?
    private let defaultSpanValue = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RunningCourseViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLocation()
        reactor = RunningCourseReactor()
        reactor?.action.onNext(.initializeLocation)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdatePolyline(_:)), name: .didUpdateLocations, object: nil)
    }
    
    @objc private func didUpdatePolyline(_ notification: Notification) {
        if let polyline = notification.object as? MKPolyline {
            runningCourseView.mapView.mapView.addOverlay(polyline)
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(runningCourseView)
        
        runningCourseView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureLocation() {
        runningCourseView.mapView.mapView.mapType = MKMapType.standard
        runningCourseView.mapView.mapView.showsUserLocation = true
        runningCourseView.mapView.mapView.delegate = self
        runningCourseView.mapView.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    private func centerMap(on location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: defaultSpanValue)
        runningCourseView.mapView.mapView.setRegion(region, animated: true)
    }

    private func addStartLocationMarker(at location: CLLocationCoordinate2D) {
        if let startAnnotation = startAnnotation {
            runningCourseView.mapView.mapView.removeAnnotation(startAnnotation)
        }
        startAnnotation = MKPointAnnotation()
        startAnnotation?.coordinate = location
        startAnnotation?.title = "시작 지점"
        if let startAnnotation = startAnnotation {
            runningCourseView.mapView.mapView.addAnnotation(startAnnotation)
        }
    }
    
    private func addStopLocationMarker(at location: CLLocationCoordinate2D) {
        if let stopAnnotation = stopAnnotation {
            runningCourseView.mapView.mapView.removeAnnotation(stopAnnotation)
        }
        stopAnnotation = MKPointAnnotation()
        stopAnnotation?.coordinate = location
        stopAnnotation?.title = "종료 지점"
        if let stopAnnotation = stopAnnotation {
            runningCourseView.mapView.mapView.addAnnotation(stopAnnotation)
        }
    }
    
    private func updatePolyline(with routeInfos: [RouteInfo]) {
        guard routeInfos.count > 1 else { return }

        let coordinates = routeInfos.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }

        if let polyline = polyline {
            runningCourseView.mapView.mapView.removeOverlay(polyline)
        }
        
        polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        runningCourseView.mapView.mapView.addOverlay(polyline!)
        
        if let region = MKCoordinateRegion(coordinates: coordinates) {
            runningCourseView.mapView.mapView.setRegion(region, animated: true)
        }
    }
}

extension RunningCourseViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension RunningCourseViewController {
    func bind(reactor: RunningCourseReactor) {
        runningCourseView.startButton.rx.tap
            .do(onNext: { [weak self] in
                self?.runningCourseView.mapView.mapView.removeOverlays(self?.runningCourseView.mapView.mapView.overlays ?? [])
            })
            .map { RunningCourseReactor.Action.startRunningCourse }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        runningCourseView.stopButton.rx.tap
            .map { RunningCourseReactor.Action.stopRunningCourse }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        runningCourseView.mapView.compassButton.rx.tap
            .map { RunningCourseReactor.Action.moveToCurrentLocation }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.routeInfos }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] routeInfos in
                self?.updatePolyline(with: routeInfos)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isRunning }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isRunning in
                self?.runningCourseView.updateRunningState(isRunning: isRunning)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.currentLocation }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] location in
                guard let location = location else { return }
                self?.centerMap(on: location)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.moveToLocation }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] location in
                guard let location = location else { return }
                self?.centerMap(on: location)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.startLocation }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] location in
                guard let location = location else { return }
                self?.addStartLocationMarker(at: location)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stopLocation }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] location in
                guard let location = location else { return }
                self?.addStopLocationMarker(at: location)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.region }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] region in
                guard let region = region else { return }
                self?.runningCourseView.mapView.mapView.setRegion(region, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
