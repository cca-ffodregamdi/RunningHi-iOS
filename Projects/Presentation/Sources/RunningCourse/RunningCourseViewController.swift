//
//  RunningCourseViewController.swift
//  Presentation
//
//  Created by 오영석 on 5/8/24.
//

import UIKit
import MapKit
import SnapKit

protocol RunningCourseViewControllerDelegate {
    func didFinishCourse()
}

final class RunningCourseViewController: UIViewController {
    
    // MARK: Properties
    var delegate: RunningCourseViewControllerDelegate?
    private let locationManager = LocationManager()
    private lazy var runningCourseView: RunningCourseView = {
        return RunningCourseView()
    }()
    
    let defaultLocation = CLLocationCoordinate2D(latitude: 36.0106098, longitude: 129.321296)
    let defaultSpanValue = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RunningCourseViewController")
    }
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
        configureUI()
    }
    
    private func configureLocation() {
        locationManager.checkUserDeviceLocationServiceAuthorization()
        runningCourseView.mapView.mapView.setRegion(MKCoordinateRegion(center: defaultLocation, span: defaultSpanValue), animated: true)
        runningCourseView.mapView.mapView.showsUserLocation = true
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(runningCourseView)
        
        runningCourseView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
