//
//  RunningCourseViewController.swift
//  Presentation
//
//  Created by 오영석 on 5/8/24.
//

import UIKit
import MapKit
import SnapKit
import RxSwift
import ReactorKit

protocol RunningCourseViewControllerDelegate: AnyObject {
    func didFinishCourse()
}

final class RunningCourseViewController: UIViewController, ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    weak var delegate: RunningCourseViewControllerDelegate?

    private lazy var runningCourseView: RunningCourseView = {
        return RunningCourseView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        reactor = RunningCourseRector()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(runningCourseView)
        
        runningCourseView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension RunningCourseViewController {
    func bind(reactor: RunningCourseRector) {
        runningCourseView.mapView.compassButton.rx.tap
            .map { Reactor.Action.centerMapOnUser }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCentering }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.centerMap()
            }
            .disposed(by: disposeBag)
    }
    
    func centerMap() {
        runningCourseView.mapView.mapView.setUserTrackingMode(.follow, animated: true)
    }
}
