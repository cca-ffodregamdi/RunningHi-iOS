//
//  RunningSettingViewController.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay

final public class RunningSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RunningCoordinatorInterface?
    
    public var disposeBag = DisposeBag()
    
    private lazy var runningView: UIView = {
        return UIView()
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RunningSettingViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .BaseWhite
        self.view.addSubview(runningView)
        
        runningView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding() {
        
    }
}
