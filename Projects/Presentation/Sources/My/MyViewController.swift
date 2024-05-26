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

class MyViewController: UIViewController, View{
    
    typealias DataSource = RxTableViewSectionedReloadDataSource<MyPageSection>
    
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
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initTableView()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.reactor = MyReactor()
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
        }
        
        self.settingTableView.snp.makeConstraints { make in
            make.top.equalTo(self.myProfileHeaderView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(500)
        }
    }
    
    func bind(reactor: MyReactor) {
        Observable.just(Reactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let dataSource = DataSource{ dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySettingCell", for: indexPath) as! SettingTableViewCell
            cell.setSectionModel(title: item.title)
            return cell
        }
        
        reactor.state.map{[MyPageSection(items: $0.items)]}
            .bind(to: settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}

//extension MyViewController: View{
//
//    func bind(reactor: MyReactor) {
//        Observable.just(Reactor.Action.load)
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
//
//
//
//        reactor.state
//            .map{ $0.sections }
//            .bind(to: settingTableView.rx.items){ tableView, index, sectionModel in
//                let section = sectionModel.section
//                let item = sectionModel.items[0]
//                let cell = tableView.dequeueReusableCell(withIdentifier: "MySettingCell", for: IndexPath(row: index, section: 0)) as! SettingTableViewCell
//                switch item{
//                case .notices(let title):
//                    cell.setSectionModel(title: title)
//                case .comment(let title):
//                    cell.setSectionModel(title: title)
//                case .myPosts(let title):
//                    cell.setSectionModel(title: title)
//                }
//                return cell
//            }
//            .disposed(by: self.disposeBag)
//    }
//}
