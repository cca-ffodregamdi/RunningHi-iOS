//
//  RecordViewController.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay
import Domain

final public class RecordViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RecordCoordinatorInterface?
    
    public var disposeBag = DisposeBag()
    
    private lazy var recordView: RecordView = {
        return RecordView()
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
        self.view.backgroundColor = .white
        self.view.addSubview(recordView)
        
        recordView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Binding

extension RecordViewController: View {
    
    public func bind(reactor: RecordReactor) {
        bindingView(reactor: reactor)
    }
    
    private func bindingView(reactor: RecordReactor) {
        Observable.just(true)
            .bind { [weak self] _ in
                guard let self = self else {return}
                self.recordView.chartTypeView.setChartType(type: .weekly)
            }
            .disposed(by: disposeBag)
        
        Observable<[Int]>.just([1,2,3,4,5])
            .bind(to: recordView.runningListView.tableView.rx.items(cellIdentifier: RecordRunningListTableViewCell.identifier, cellType: RecordRunningListTableViewCell.self)) { index, model, cell in
            }
            .disposed(by: disposeBag)
        
        self.recordView.runningListView.tableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.recordView.runningListView.tableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
    }
}
