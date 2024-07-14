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

final public class ChallengeViewController: UIViewController{
    
    // MARK: Properties
    public var disposeBag: DisposeBag = DisposeBag()
    public var coordinator: ChallengeCoordinatorInterface?
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ChallengeSectionModel>!
    
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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 84
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionHeaderHeight = tableView.estimatedSectionHeaderHeight
        tableView.register(ChallengeTableViewCell.self, forCellReuseIdentifier: "challengeCell")
        tableView.register(ChallengeHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "challengeHeaderView")
        return tableView
    }()
    
    // MARK: LifeCyecle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBarItem()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "챌린지"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    public init(reactor: ChallengeReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
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
            make.left.right.width.bottom.equalToSuperview()
        }
    }
}

extension ChallengeViewController: View{
    
    public func bind(reactor: ChallengeReactor) {
        reactor.action.onNext(.fetchChallenge)
        reactor.action.onNext(.fetchMyChallenge)
        
        self.dataSource = RxTableViewSectionedReloadDataSource<ChallengeSectionModel>(configureCell:{ dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
            switch item{
            case .participating(let myChallengeModel):
                cell.configureWithMyChallengeModel(model: myChallengeModel)
            case .notParticipaing(let challgensModel):
                cell.configureModel(model: challgensModel)
            }
            return cell
        })
        
        reactor.state.map{$0.section}
            .bind(to: challengeTableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.challengeTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.challengeTableView.rx.modelSelected(ChallengeItem.self)
            .bind{ [weak self] item in
                guard let self = self else {return}
                var challengeId: Int
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                switch item{
                case .participating(let myChallengeModel):
                    challengeId = myChallengeModel.challengeId
                    self.coordinator?.showChallengeDetailView(viewController: self, challengeId: challengeId, isParticipated: true)
                case .notParticipaing(let challengeModel):
                    challengeId = challengeModel.challengeId
                    self.coordinator?.showChallengeDetailView(viewController: self, challengeId: challengeId, isParticipated: false)
                }
            }.disposed(by: self.disposeBag)
        
        challengeTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.challengeTableView.snp.updateConstraints({ make in
                    make.height.equalTo(size.height)
                })
            }.disposed(by: self.disposeBag)
    }
    
   
}
extension ChallengeViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "challengeHeaderView") as! ChallengeHeaderFooterView
        headerView.configureModel(title: dataSource[section].header)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


extension ChallengeViewController: ChallengeDetailViewControllerDelegate{
    public func joined() {
        reactor?.action.onNext(.fetchChallenge)
        reactor?.action.onNext(.fetchMyChallenge)
    }
}
