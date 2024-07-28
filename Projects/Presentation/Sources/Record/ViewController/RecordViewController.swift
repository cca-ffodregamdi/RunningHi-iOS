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
        binding(reactor: reactor)
        bindingAction(reactor: reactor)
        bindingState(reactor: reactor)
    }
    
    private func binding(reactor: RecordReactor) {
        Observable.just(true)
            .bind { [weak self] _ in
                guard let self = self else {return}
                self.recordView.chartTypeView.setChartType(type: .weekly)
                reactor.action.onNext(.tapChartType(.weekly))
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
    
    private func bindingAction(reactor: RecordReactor) {
        let weeklyChartTap = recordView.chartTypeView.weeklyButton.rx.tap
            .map {
                self.recordView.chartTypeView.setChartType(type: .weekly)
                return Reactor.Action.tapChartType(.weekly)
            }
        let monthlyChartTap = recordView.chartTypeView.monthlyButton.rx.tap
            .map {
                self.recordView.chartTypeView.setChartType(type: .monthly)
                return Reactor.Action.tapChartType(.monthly)
            }
        let yearlyChartTab = recordView.chartTypeView.yearlyButton.rx.tap
            .map {
                self.recordView.chartTypeView.setChartType(type: .yearly)
                return Reactor.Action.tapChartType(.yearly)
            }
        
        Observable.merge(weeklyChartTap, monthlyChartTap, yearlyChartTab)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindingState(reactor: RecordReactor) {
        reactor.state
            .compactMap{ $0.recordData }
            .skip(1)
            .bind{ [weak self] data in
                guard let self = self else { return }
                print(data)
                self.recordView.setData(data: data)
            }.disposed(by: self.disposeBag)
    }
}
