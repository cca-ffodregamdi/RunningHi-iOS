//
//  MyViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import Common

final public class MyViewController: UIViewController{
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    typealias DataSource = RxTableViewSectionedReloadDataSource<MyPageSection>
    
    public var coordinator: MyCoordinatorInterface?
    
    // MARK: Properties
    private lazy var myView: MyView = {
        return MyView()
    }()
    
    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    public init(reactor: MyReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .Secondary100
        self.view.addSubview(myView)
        
        myView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func showLogoutAlert(){
        let alertView = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
        }
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alertView.addAction(cancel)
        alertView.addAction(logout)
        self.present(alertView, animated: true)
    }
}

extension MyViewController: View{
    public func bind(reactor: MyReactor) {
        Observable.just(Reactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let dataSource = DataSource{ dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
            cell.setSectionModel(model: item)
            return cell
        }
        
        reactor.state.map{[MyPageSection(items: $0.items)]}
            .bind(to: myView.settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        myView.settingTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else { return }
                self.myView.settingTableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
        
        myView.settingTableView.rx.itemSelected
            .bind{ [weak self] indexPath in
                guard let self = self else { return }
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                switch dataSource[indexPath]{
                case .notices:
                    self.coordinator?.showNotice()
                case .customerCenter:
                    self.coordinator?.showCustomerCenter()
                case .logOut:
                    self.showLogoutAlert()
                default: break
                }
            }.disposed(by: self.disposeBag)
        myView.settingTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension MyViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingFooterView.identifier) as! SettingFooterView
        if let dictionary = Bundle.main.infoDictionary{
            if let version = dictionary["CFBundleShortVersionString"] as? String{
                footerView.configureModel(version: "v.\(version)")
            }
        }
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58
    }
}
