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

final public class MyViewController: UIViewController, View{
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    typealias DataSource = RxTableViewSectionedReloadDataSource<MyPageSection>
    
    public var coordinator: MyCoordinatorInterface?
    
    // MARK: Properties
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var myProfileHeaderView: MyProfileHeaderView = {
        return MyProfileHeaderView()
    }()
    
    private lazy var settingTableView: UITableView = {
        var tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.rowHeight = 56
        return tableView
    }()
    
    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initTableView()
    }
    
    public init(reactor: MyReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initTableView(){
        self.settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "MySettingCell")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(myProfileHeaderView)
        self.scrollView.addSubview(settingTableView)
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        self.myProfileHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        self.settingTableView.snp.makeConstraints { make in
            make.top.equalTo(self.myProfileHeaderView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(settingTableView.contentSize.height)
        }
    }
    
    public func bind(reactor: MyReactor) {
        Observable.just(Reactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let dataSource = DataSource{ dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySettingCell", for: indexPath) as! SettingTableViewCell
            cell.setSectionModel(model: item)
            return cell
        }
        
        reactor.state.map{[MyPageSection(items: $0.items)]}
            .bind(to: settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        settingTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else { return }
                settingTableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
    }
}
