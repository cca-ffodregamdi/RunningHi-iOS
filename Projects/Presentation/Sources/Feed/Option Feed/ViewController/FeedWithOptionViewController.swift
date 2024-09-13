//
//  FeedWithOptionViewController.swift
//  Presentation
//
//  Created by 유현진 on 7/27/24.
//

import UIKit
import Common
import SnapKit
import ReactorKit
import RxDataSources
import RxSwift
import RxCocoa
import Domain

public protocol FeedWithOptionViewControllerDelgate: AnyObject{
    func updatedBookmarkFeed(postId: Int)
}

public class FeedWithOptionViewController: UIViewController {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: FeedCoordinatorInterface?
    
    public weak var delegate: FeedWithOptionViewControllerDelgate?
    
    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FeedModel>>!
    
    private lazy var feedView: FeedView = {
        return FeedView()
    }()
    
    private lazy var feedRefreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        setFeedCollectionView()
    }
    
    public init(reactor: FeedWithOptionReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.backgroundColor = UIColor.colorWithRGB(r: 231, g: 235, b: 239)
        
        self.view.addSubview(feedView)
        
        feedView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func addRefreshControl(){
        feedView.feedCollectionView.refreshControl = feedRefreshControl
        feedRefreshControl.endRefreshing()
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setFeedCollectionView(){
        let layout = PinterestLayout()
        layout.delegate = self
        feedView.feedCollectionView.collectionViewLayout = layout
        
        feedView.feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "bookmarkedCell")
        
        addRefreshControl()
    }
}

extension FeedWithOptionViewController: View{
    public func bind(reactor: FeedWithOptionReactor) {
        
        reactor.action.onNext(.fetchFeeds)
        
        self.dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FeedModel>>(configureCell: {
            dataSource, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkedCell", for: indexPath) as! FeedCollectionViewCell
            
            cell.configureModel(model: model)
            cell.disposeBag = DisposeBag()
            
            if reactor.currentState.feedOption == .bookmark{
                cell.bookmarkButton.rx
                    .tap
                    .map{ Reactor.Action.deleteBookmark(model.postId) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }else{
                cell.bookmarkButton.isHidden = true
            }
            return cell
        })
        
        reactor.state
            .map{[AnimatableSectionModel(model: "feedModel", items: $0.feeds)]}
            .bind(to: self.feedView.feedCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.feeds }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.feedView.feedCollectionView.collectionViewLayout.invalidateLayout()
            }
            .disposed(by: self.disposeBag)
        
        feedRefreshControl.rx.controlEvent(.valueChanged)
            .map{Reactor.Action.refresh}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.isRefreshing}
            .distinctUntilChanged()
            .bind{ _ in
                self.feedRefreshControl.endRefreshing()
            }.disposed(by: self.disposeBag)
        
        self.feedView.feedCollectionView.rx.itemSelected
            .bind{ [weak self] indexPath in
                guard let self = self else { return }
                let model = self.dataSource[indexPath]
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showFeedDetailByBookmarkedFeed(viewController: self, postId: model.postId)
            }.disposed(by: self.disposeBag)
        
        self.feedView.feedCollectionView.rx.contentOffset
            .map{$0.y}
            .distinctUntilChanged()
            .filter{ [weak self] offset in
                guard let self = self else { return false }
                return offset + self.feedView.feedCollectionView.frame.size.height + 300 > self.feedView.feedCollectionView.contentSize.height
            }.map{ _ in Reactor.Action.fetchFeeds }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.feedOption}
            .map{ type in
                switch type{
                case .bookmark: return "북마크"
                case .myFeed: return "나의 피드"
                }
            }.bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
    }
}

extension FeedWithOptionViewController: FeedDetailViewControllerDelegate{
    public func deleteFeed(postId: Int) {
        reactor?.action.onNext(.deleteFeed(postId))
    }
    
    public func editedFeed(postId: Int) {
        reactor?.action.onNext(.fetchOneOfFeeds(postId))
    }
    
    public func bookmarkedFeed(postId: Int) {
        guard let reactor = reactor else { return }
        if reactor.currentState.feedOption == .bookmark{
            reactor.action.onNext(.deleteFeed(postId))
            delegate?.updatedBookmarkFeed(postId: postId)
        }
    }
}

extension FeedWithOptionViewController: PinterestLayoutDelegate{
    public func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let model = self.dataSource[indexPath]
        return model.imageUrl == nil ? collectionView.bounds.height / 3 : collectionView.bounds.height / 2
    }
}
