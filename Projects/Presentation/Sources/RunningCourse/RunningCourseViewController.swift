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
    
    private lazy var runningCourseView: RunningCourseView = {
        return RunningCourseView()
    }()
    
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
        configureUI()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(runningCourseView)
        
        runningCourseView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
