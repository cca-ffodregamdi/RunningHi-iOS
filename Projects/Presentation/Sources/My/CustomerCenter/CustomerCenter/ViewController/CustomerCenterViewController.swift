//
//  CustomerCenterViewController.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import Domain
import SnapKit

public class CustomerCenterViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: MyCoordinatorInterface?
    
    private lazy var customerCenterView: CustomerCenterView = {
        return CustomerCenterView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public init(reactor: CustomerCenterReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBar(){
        self.title = "고객센터"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(customerCenterView)
        
        customerCenterView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
extension CustomerCenterViewController: View{
    public func bind(reactor: CustomerCenterReactor) {
        
        reactor.state.map{$0.mode}
            .distinctUntilChanged()
            .map{
                switch $0{
                case .FAQ:
                    return Reactor.Action.fetchFAQ
                case .Feedback:
                    return Reactor.Action.fetchFeedback
                }
            }.observe(on: MainScheduler.asyncInstance)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<CustomerCenterSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            switch item{
            case .faq(let models):
                let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.identifier, for: indexPath) as! FAQTableViewCell
                cell.configureModel(faqModel: models, isExpanded: reactor.currentState.expandedIndex.contains(indexPath))
                return cell
            case .feedback(let models):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.identifier, for: indexPath) as! FeedbackTableViewCell
                cell.configureModel(feedbackModel: models)
                return cell
            }
        })
        
        customerCenterView.customerCenterTableView.rx
            .modelSelected(CustomerCenterItemType.self)
            .subscribe(onNext:{ [weak self] item in
                switch item{
                case .faq(let _):
                    break
                case .feedback(let model):
                    self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                    self?.coordinator?.showFeedbackDetail(feedbackId: model.feedbackId)
                }
            }).disposed(by: self.disposeBag)
        
        customerCenterView.customerCenterTableView.rx
            .itemSelected
            .map{ Reactor.Action.toggleExpand($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        reactor.state.map{$0.sections}
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: customerCenterView.customerCenterTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        customerCenterView.headerButtonView.faqButton.rx
            .tap
            .map{ Reactor.Action.setMode(.FAQ)}
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        customerCenterView.headerButtonView.feedbackButton.rx
            .tap
            .map{ Reactor.Action.setMode(.Feedback)}
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.mode}
            .bind{ [weak self] in
                guard let self = self else { return }
                self.customerCenterView.headerButtonView.toggleButton(mode: $0)
                self.customerCenterView.isHiddenCreateFeedbackButton(mode: $0)
            }.disposed(by: self.disposeBag)
        
        customerCenterView.createFeedbackButton.rx
            .tap
            .bind{ [weak self] in
                guard let self = self else { return }
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showMakeFeedback(viewController: self)
            }.disposed(by: self.disposeBag)
    }
}

extension CustomerCenterViewController: MakeFeedbackViewControllerDelegate{
    public func madeFeedback() {
        reactor?.action.onNext(.fetchFeedback)
    }
}
