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

final public class RunningViewController: UIViewController {
    
    public var coordinator: TabBarCoordinatorInterface?
    public var rootViewController: UIViewController?
    
    public var disposeBag = DisposeBag()
    
//    private lazy var runningPopupView: RunningPopupView = {
//        return RunningPopupView(tabBarHeight: tabBarHeight)
//    }()
    
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
    
    private func configureUI() {
        self.view.backgroundColor = .BaseWhite
//        self.view.addSubview(runningPopupView)
        
//        runningPopupView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    
    private func binding() {
        
    }
}
