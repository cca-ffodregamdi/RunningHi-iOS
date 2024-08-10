//
//  AccessViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/6/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

public protocol LoginViewControllerDelegate: AnyObject{
    func login()
}

public final class AccessViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    weak var delegate: LoginViewControllerDelegate?
    
    public var coordinator: LoginCoordinatorInterface?
    
    private lazy var accessView: AccessView = {
        return AccessView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }

    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public init(reactor: AccessReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(accessView)
        
        accessView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension AccessViewController: View{
    public func bind(reactor: AccessReactor) {
        reactor.state
            .map{$0.accessModel}
            .bind(to: accessView.accessTableView.rx.items(cellIdentifier: AccessTableViewCell.identifier, cellType: AccessTableViewCell.self)){ index, model, cell in
                cell.configureModel(title: model)
                
                cell.checkButton.rx
                    .tap
                    .map{ Reactor.Action.checkRow(index) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                reactor.state
                    .map{$0.checkArray[index]}
                    .bind(to: cell.checkButton.rx.isSelected)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
        
        accessView.accessTableView.rx.itemSelected
            .bind{ [weak self] indexPath in
                guard let self = self else { return }
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showAccessDetail(index: indexPath.row)
            }.disposed(by: self.disposeBag)
        
        accessView.accessTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        let checkArrayObserver =
        reactor.state
            .map{$0.checkArray}
            .map{$0.allSatisfy { $0 == true}}
            .distinctUntilChanged()
            .asObservable()
        
        checkArrayObserver
            .bind(to: accessView.nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
            
        checkArrayObserver
            .bind{ [weak self] isEnabled in
                guard let self = self else { return }
                self.accessView.updateNextButtonUI(bool: isEnabled)
            }.disposed(by: self.disposeBag)
        
        accessView.nextButton.rx
            .tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.signIn)
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.successedSignIn}
            .distinctUntilChanged()
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.successedSignIn()
            }.disposed(by: self.disposeBag)
    }
}

extension AccessViewController: UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccessFooterView.identifiter) as! AccessFooterView
        guard let reactor = reactor else { return nil}
        
        reactor.state
            .map{$0.checkAllState}
            .bind(to: footer.checkButton.rx.isSelected)
            .disposed(by: footer.disposeBag)
        
        footer.tapGesture.rx
            .event
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{_ in Reactor.Action.touchUpCheckAllButton}
            .bind(to: reactor.action)
            .disposed(by: footer.disposeBag)
        
        return footer
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
