//
//  RunningMapViewController.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import UIKit
import MapKit
import Domain

final public class RunningMapViewController: UIViewController, MKMapViewDelegate {
    
    lazy var mapView = RunningMapView()
    
    let delegate = RunningMapDelegate()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(runningResult: RunningResult){
        super.init(nibName: nil, bundle: nil)
        
        self.mapView.configureMap(runningResult: runningResult)
        self.mapView.delegate = delegate
    }
    
    deinit {
        print("deinit RunningMapViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureNavigationBar() {
        self.title = nil
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func configureUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
