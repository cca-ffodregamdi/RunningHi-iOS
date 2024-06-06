//
//  ChallengeDetaileViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/30/24.
//

import UIKit
import SnapKit
import Domain
import RxDataSources
import RxSwift
import RxCocoa
import ReactorKit
import Common

final public class ChallengeDetailViewController: UIViewController{

    // MARK: Properties
    var challengeModel: ChallengeModel
    public var disposeBag: DisposeBag = DisposeBag()
    public var coordinator: ChallengeCoordinatorInterface?
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, RankModel>>!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return scrollView
    }()
    
    private lazy var challengeDetailInfoView: ChallengeDetailInfoView = {
        return ChallengeDetailInfoView()
    }()
    
    private lazy var challengeDetailHeaderView: ChallengeDetailHeaderView = {
        return ChallengeDetailHeaderView()
    }()
    
    private lazy var rankTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RankTableViewCell.self, forCellReuseIdentifier: "rankCell")
        tableView.register(RankHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "rankHeaderView")
        return tableView
    }()
    
    // MARK: LifeCyecle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
    }
    
    public init(challengeModel: ChallengeModel, reactor: ChallengeDetailReactor) {
        self.challengeModel = challengeModel
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(scrollView)
        
        [challengeDetailInfoView, challengeDetailHeaderView, rankTableView].forEach{
            self.scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        challengeDetailHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
        
        challengeDetailInfoView.snp.makeConstraints { make in
            make.top.equalTo(challengeDetailHeaderView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        rankTableView.snp.makeConstraints { make in
            make.top.equalTo(challengeDetailInfoView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(rankTableView.contentSize.height+230)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureNavigationBar(){
        self.title = self.challengeModel.title

        self.navigationController?.navigationBar.sizeToFit()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.backgroundColor = .systemBackground
        scrollAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = scrollAppearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension ChallengeDetailViewController: View, UITableViewDelegate{

    public func bind(reactor: ChallengeDetailReactor) {
        reactor.action.onNext(.fetchRank)
        
        self.dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, RankModel>>(configureCell: {
            dataSource, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankCell", for: indexPath) as! RankTableViewCell
            cell.configureModel(model: model)
            return cell
        })
        
        reactor.state.map{[SectionModel(model: "otherRanks", items: $0.otherRank)]}
            .bind(to: self.rankTableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.rankTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.topRank }
            .bind{ [weak self] topRanks in
                guard let self = self else { return }
                guard let headerView = self.rankTableView.dequeueReusableHeaderFooterView(withIdentifier: "rankHeaderView") as? RankHeaderFooterView else { return }
                headerView.configureModel(models: topRanks)
                headerView.frame.size = .init(width: self.view.bounds.width, height: 230)
                self.rankTableView.tableHeaderView = headerView
            }.disposed(by: disposeBag)
    }
}

