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
    
    private var stickyViewHeight: NSLayoutConstraint?
    
    private let stickViewDefaultHeight: CGFloat = UIScreen.main.bounds.height / 3
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, RankModel>>!
    
    private lazy var stickyImageView: StickyImageView = {
        return StickyImageView(frame: .zero)
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여하기", for: .normal)
        button.setTitleColor(UIColor.colorWithRGB(r: 250, g: 250, b: 250), for: .normal)
        button.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = .white
        scrollView.clipsToBounds = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var challengeDetailInfoView: ChallengeDetailInfoView = {
        return ChallengeDetailInfoView()
    }()
    
    private lazy var infoRankBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var rankTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(RankTableViewCell.self, forCellReuseIdentifier: "rankCell")
        tableView.register(RankHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "rankHeaderView")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()
    
    private lazy var myRankView: MyRankView = {
        return MyRankView()
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
    
    public override func viewDidLayoutSubviews() {
        joinButton.layer.cornerRadius = joinButton.bounds.height * 0.5
    }
    
    private func configureUI(){
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stickyImageView)
        self.scrollView.addSubview(challengeDetailInfoView)
        self.scrollView.addSubview(infoRankBreakLine)
        self.scrollView.addSubview(rankTableView)
        self.view.addSubview(joinButton)
        self.view.addSubview(myRankView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        stickyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(stickViewDefaultHeight)
        }
        
        challengeDetailInfoView.snp.makeConstraints { make in
            make.top.equalTo(stickyImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        infoRankBreakLine.snp.makeConstraints { make in
            make.top.equalTo(challengeDetailInfoView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
        
        rankTableView.snp.makeConstraints { make in
            make.top.equalTo(infoRankBreakLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        
        joinButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        myRankView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(58)
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
    
    private func remakeAutoLayoutWithRankTableView(){
        // 참여하기 버튼이 없을 경우 하단 여백 제거
        self.rankTableView.snp.remakeConstraints { make in
            make.top.equalTo(self.infoRankBreakLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
                    self.challengeDetailInfoView.configureModel(content: model.content, goalDetail: model.goalDetail, startDate: model.startDate, endDate: model.endDate, participatedCount: model.participantsCount)
                    self.stickyImageView.setImage(urlString: "https://firebasestorage.googleapis.com/v0/b/weather-wear-a7674.appspot.com/o/20231102-1.JPG?alt=media")
                    self.title = model.title
                    self.rankTableView.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(-30)
                    }
                }else{
                    guard let model = reactor.currentState.otherChallengeDetailModel else { return }
                    self.challengeDetailInfoView.configureModel(content: model.content, goalDetail: model.goalDetail, startDate: model.startDate, endDate: model.endDate, participatedCount: model.participantsCount)
                    self.stickyImageView.setImage(urlString: "https://firebasestorage.googleapis.com/v0/b/weather-wear-a7674.appspot.com/o/20231102-1.JPG?alt=media")
                    self.title = model.title
                }
            }.disposed(by: self.disposeBag)
        
        self.dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, RankModel>>(configureCell: {
            dataSource, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankCell", for: indexPath) as! RankTableViewCell
            let challengeCategory: String
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
            .bind(to: self.rankTableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.rankTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.rankTableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
        
 
//        let tapGesture = UITapGestureRecognizer()
//        stickyImageView.addGestureRecognizer(tapGesture)
//        stickyImageView.isUserInteractionEnabled = true
//        tapGesture.rx.event
//            .bind{ [weak self] _ in
//                guard let self = self else { return }
//                let vc = ThumbnailImageViewController(imageUrl: url)
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true)
//            }.disposed(by: self.disposeBag)
        
        self.rankTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .bind(to: self.joinButton.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .bind{ [weak self] isParticipated in
                guard let self = self else { return }
                if isParticipated{
                    guard let model = reactor.currentState.myChallengeDetailModel else { return }
                    self.challengeDetailInfoView.configureAchievementRateView(category: model.challengeCategory, isParticipated: true, record: model.record, goal: model.goal)
                }else{
                    guard let model = reactor.currentState.otherChallengeDetailModel else { return }
                    self.challengeDetailInfoView.configureAchievementRateView(category: model.challengeCategory, isParticipated: false, record: nil, goal: nil)
                }
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .map{!$0}
            .distinctUntilChanged()
            .bind(to: myRankView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isParticipated}
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                guard let model = reactor.currentState.myChallengeDetailModel else { return }
                self.myRankView.configureModel(model: model.myRanking, challengeCategory: model.challengeCategory)
            }.disposed(by: self.disposeBag)
        
        joinButton.rx.tap
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
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "rankHeaderView") as? RankHeaderFooterView else { return nil }
        guard let reactor = reactor else { return nil }
        let challengeCategory: String
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

