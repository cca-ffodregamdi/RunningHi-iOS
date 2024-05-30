//
//  ChallengeViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/28/24.
//

import UIKit
import SnapKit
import RxSwift
import ReactorKit
import RxCocoa
import RxDataSources
import Domain
import Common

final class ChallengeViewController: UIViewController{
    
    // MARK: Properties
    var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ChallengeSection>!
    
    private lazy var challengeHeaderView: ChallengeHeaderView = {
        return ChallengeHeaderView()
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bellOutline.image, for: .normal)
        return button
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private lazy var challengeTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.backgroundColor = UIColor.colorWithRGB(r: 231, g: 235, b: 239)
        tableView.isScrollEnabled = false
//        tableView.alwaysBounceVertical = true
//        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = 84
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionHeaderHeight = tableView.estimatedSectionHeaderHeight
        tableView.register(ChallengeTableViewCell.self, forCellReuseIdentifier: "challengeCell")
        tableView.register(ChallengeHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "challengeHeaderView")
        return tableView
    }()
    
    // MARK: LifeCyecle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBarItem()
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.reactor = ChallengeReactor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBarItem(){
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: notificationButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
    
    private func configureUI(){
        self.view.backgroundColor = UIColor.colorWithRGB(r: 231, g: 235, b: 239)
        self.view.addSubview(scrollView)
        
        [challengeHeaderView, challengeTableView].forEach{
            self.scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        challengeHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        challengeTableView.snp.makeConstraints { make in
            make.top.equalTo(challengeHeaderView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-(self.challengeHeaderView.bounds.height))
        }
    }
}

extension ChallengeViewController: View, UITableViewDelegate{

    func bind(reactor: ChallengeReactor) {
        Observable.just(Reactor.Action.fetchChallenge)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.dataSource = RxTableViewSectionedReloadDataSource<ChallengeSection>(configureCell:{ dataSource, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
            cell.configureModel(model: model)
            return cell
        })
        
        reactor.state.map{$0.section}
            .bind(to: challengeTableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.challengeTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "challengeHeaderView") as! ChallengeHeaderFooterView
        headerView.configureModel(title: dataSource[section].header)
        return headerView
    }
}
