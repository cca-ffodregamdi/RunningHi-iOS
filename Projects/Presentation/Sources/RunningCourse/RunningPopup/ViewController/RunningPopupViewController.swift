//
//  RunningPopupViewController.swift
//  Presentation
//
//  Created by najin on 7/2/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay

final public class RunningPopupViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: TabBarCoordinatorInterface?
    public var tabViewController: UITabBarController?
    public var rootViewController: UIViewController?
    
    public var disposeBag = DisposeBag()
    
    private lazy var runningPopupView: RunningPopupView = {
        return RunningPopupView(tabBarHeight: tabViewController?.tabBar.frame.size.height ?? 0.0)
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RunningCourseViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .clear
        self.view.addSubview(runningPopupView)
        
        runningPopupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //TODO: 나중에 RxGesture로 변경하기
        let tapGesture = UITapGestureRecognizer()
        runningPopupView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(dismissPopupView))
    }
    
    @objc func dismissPopupView() {
        if let vc = rootViewController, let tab = tabViewController as? TabBarViewController {
            tab.toggleCourseTabBar(isActive: false)
            coordinator?.cancelRunningPopup(vc)
        }
    }
    
    private func binding() {
        
        runningPopupView.freeRunningButton.rx.tap
            .bind {
                self.dismissPopupView()
                self.coordinator?.showRunning(isFreeCourse: true)
            }
            .disposed(by: disposeBag)
        
        runningPopupView.myRunningButton.rx.tap
            .bind {
                self.dismissPopupView()
                self.coordinator?.showRunning(isFreeCourse: false)
            }
            .disposed(by: disposeBag)
    }
}
