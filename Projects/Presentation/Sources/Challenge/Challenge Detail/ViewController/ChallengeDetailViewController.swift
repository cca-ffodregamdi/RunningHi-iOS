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

public protocol ChallengeDetailViewControllerDelegate: AnyObject{
    func joined()
}

final public class ChallengeDetailViewController: UIViewController{

    // MARK: Properties
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: ChallengeCoordinatorInterface?
    
    public weak var delegate: ChallengeDetailViewControllerDelegate?
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, RankModel>>!
    
    private lazy var challengeDetailView: ChallengeDetailView = {
        return ChallengeDetailView()
    }()
    
    // MARK: LifeCyecle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    public init(reactor: ChallengeDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(challengeDetailView)
        
        challengeDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.configureWithOpaqueBackground()
        scrollAppearance.backgroundColor = .systemBackground
        scrollAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = scrollAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension ChallengeDetailViewController: View{

    public func bind(reactor: ChallengeDetailReactor) {
        reactor.action.onNext(.fetchChallengeInfo)
        
        reactor.state.map{$0.isFetched}
            .filter{$0}
            .distinctUntilChanged()
            .bind{ [weak self] _ in
                guard let self = self else { return }
                if reactor.currentState.isParticipated{
                    guard let model = reactor.currentState.myChallengeDetailModel else { return }
                    self.challengeDetailView.challengeDetailInfoView.configureModel(content: model.content, goalDetail: model.goalDetail, startDate: model.startDate, endDate: model.endDate, participatedCount: model.participantsCount)
                    self.challengeDetailView.headerImageView.setImage(urlString: model.imageUrl)
                    self.title = model.title
                    self.challengeDetailView.rankTableView.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(-30)
                    }
                }else{
                    guard let model = reactor.currentState.otherChallengeDetailModel else { return }
                    self.challengeDetailView.challengeDetailInfoView.configureModel(content: model.content, goalDetail: model.goalDetail, startDate: model.startDate, endDate: model.endDate, participatedCount: model.participantsCount)
                    self.challengeDetailView.headerImageView.setImage(urlString: model.imageUrl)
                    self.title = model.title
                }
            }.disposed(by: self.disposeBag)
        
        self.dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, RankModel>>(configureCell: {
            dataSource, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewCell.identifier, for: indexPath) as! RankTableViewCell
            let challengeCategory: ChallengeCategoryType
            if reactor.currentState.isParticipated{
                guard let myChallengeModel = reactor.currentState.myChallengeDetailModel else { return RankTableViewCell() }
                challengeCategory = myChallengeModel.challengeCategory
            }else{
                guard let otherChallengeModel = reactor.currentState.otherChallengeDetailModel else { return RankTableViewCell() }
                challengeCategory = otherChallengeModel.challengeCategory
            }
            
            cell.configureModel(model: model, challengeCategory: challengeCategory)
            return cell
        })
        
        reactor.state.map{[SectionModel(model: "otherRanks", items: $0.otherRank)]}
            .bind(to: self.challengeDetailView.rankTableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        challengeDetailView.rankTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.challengeDetailView.rankTableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
        
        challengeDetailView.rankTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .bind(to: challengeDetailView.joinButton.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .bind{ [weak self] isParticipated in
                guard let self = self else { return }
                if isParticipated{
                    guard let model = reactor.currentState.myChallengeDetailModel else { return }
                    self.challengeDetailView.challengeDetailInfoView.configureAchievementRateView(categoryModel: ChallengeCategory(category: model.challengeCategory, record: model.record, goal: model.goal), isParticipated: true)
                }else{
                    guard let model = reactor.currentState.otherChallengeDetailModel else { return }
                    self.challengeDetailView.challengeDetailInfoView.configureAchievementRateView(categoryModel: nil, isParticipated: false)
                }
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .map{!$0}
            .distinctUntilChanged()
            .bind(to: challengeDetailView.myRankView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                guard let model = reactor.currentState.myChallengeDetailModel else { return }
                self.challengeDetailView.myRankView.configureModel(model: model.myRanking, challengeCategory: model.challengeCategory)
            }.disposed(by: self.disposeBag)
        
        challengeDetailView.joinButton.rx.tap
            .map{ _ in
                return Reactor.Action.joinChallenge(JoinChallengeRequestDTO(challengeId: reactor.currentState.challengeId))
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isJoined}
            .filter{$0}
            .distinctUntilChanged()
            .bind{ [weak self] _ in
                guard let self = self else {return}
                self.delegate?.joined()
            }.disposed(by: self.disposeBag)
    }
}

extension ChallengeDetailViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: RankHeaderFooterView.identifier) as? RankHeaderFooterView else { return nil }
        guard let reactor = reactor else { return nil }
        let challengeCategory: ChallengeCategoryType
        if reactor.currentState.isParticipated{
            guard let myChallengeModel = reactor.currentState.myChallengeDetailModel else { return nil }
            challengeCategory = myChallengeModel.challengeCategory
        }else{
            guard let otherChallengeModel = reactor.currentState.otherChallengeDetailModel else { return nil }
            challengeCategory = otherChallengeModel.challengeCategory
        }
        view.configureModel(models: reactor.currentState.topRank, challengeCategory: challengeCategory)
        return view
    }
}

