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
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<ChallengeSectionModel>!
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bellOutline.image, for: .normal)
        return button
    }()
    
    private lazy var challengeView: ChallengeView = {
        return ChallengeView()
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
        self.view.backgroundColor = .Secondary100
        self.view.addSubview(challengeView)
        
        challengeView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
}

extension ChallengeViewController: View{
    
    public func bind(reactor: ChallengeReactor) {
        reactor.action.onNext(.fetchChallenge)
        reactor.action.onNext(.fetchMyChallenge)
        
        self.dataSource = RxCollectionViewSectionedReloadDataSource<ChallengeSectionModel>(configureCell:{ dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as! ChallengeCollectionViewCell
            
            switch item{
            case .participating(let myChallengeModel):
                cell.configureWithMyChallengeModel(model: myChallengeModel)
            case .notParticipaing(let challgensModel):
                cell.configureModel(model: challgensModel)
            }
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChallengeCollectionReusableView.identifier, for: indexPath) as! ChallengeCollectionReusableView
            header.configureModel(title: dataSource[indexPath.section].header, count: dataSource[indexPath.section].items.count)
            return header
        })
        
        reactor.state.map{$0.section}
            .bind(to: challengeView.challengeCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        challengeView.challengeCollectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        challengeView.challengeCollectionView.rx.modelSelected(ChallengeItem.self)
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
    }
}

extension ChallengeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 96)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}

extension ChallengeViewController: ChallengeDetailViewControllerDelegate{
    public func joined() {
        reactor?.action.onNext(.fetchChallenge)
        reactor?.action.onNext(.fetchMyChallenge)
    }
}
