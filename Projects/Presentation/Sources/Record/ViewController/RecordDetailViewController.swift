//
//  RecordDetailViewController.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay
import Domain

final public class RecordDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RecordCoordinatorInterface?
    
    public var disposeBag = DisposeBag()
    
    private lazy var runningView: RunningView = {
        return RunningView()
    }()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RecordReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    deinit {
        print("deinit RunningViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .BaseWhite
        self.view.addSubview(runningView)
        
        runningView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Binding

extension RecordDetailViewController: View {
    
    public func bind(reactor: RecordReactor) {
    }
}
