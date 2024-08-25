//
//  SignOutViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit
import RxDataSources

public class SignOutViewController: UIViewController {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: MyCoordinatorInterface?
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SignOutReasonSection>!
    
    private lazy var signOutView: SignOutView = {
        return SignOutView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    public init(reactor: SignOutReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.addSubview(signOutView)
        
        signOutView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureNavigationBar(){
        self.title = "탈퇴하기"
        self.navigationController?.navigationBar.tintColor = .black
    }
}
extension SignOutViewController: View{
    public func bind(reactor: SignOutReactor) {
        
        self.dataSource = RxTableViewSectionedReloadDataSource<SignOutReasonSection>(configureCell: {dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: SignOutTableViewCell.identifier, for: indexPath) as! SignOutTableViewCell
            cell.configureModel(reasonModel: item, isChecked: reactor.currentState.selectedSectionIndex == indexPath.section)
            return cell
        })
        
        reactor.state.map{$0.reasonList}
            .bind(to: signOutView.signOutTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        signOutView.signOutTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        signOutView.signOutTableView.rx.itemSelected
            .map{ [weak self] item in
                self?.view.endEditing(true)
                return Reactor.Action.selectedSection(item.section)
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension SignOutViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SignOutFooterView.identifier) as? SignOutFooterView else { return nil }
        guard section == reactor?.currentState.selectedSectionIndex else { return nil }
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == reactor?.currentState.selectedSectionIndex ? 84 : 0
    }
}
