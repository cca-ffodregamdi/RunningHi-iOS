//
//  FeedViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit
import ReactorKit
import Common
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources
import Domain

final public class FeedViewController: UIViewController{
    
    // MARK: Properties
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: FeedCoordinatorInterface?
    
    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FeedModel>>!
    
    private lazy var showBookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bookmarkOutline.image, for: .normal)
        return button
    }()
    
    private lazy var announceButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bellOutline.image, for: .normal)
        return button
    }()
    
    private lazy var feedAndFilterView: FeedAndFilterView = {
        return FeedAndFilterView()
    }()
    
    private lazy var feedRefreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBarItem()
        addRefreshControl()
        setFeedCollectionView()
    }
    
    deinit{
        print("deinit FeedViewController")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
//        Observable.just(Reactor.Action.refresh)
//            .bind(to: reactor!.action)
//            .disposed(by: self.disposeBag)
    }
    
    private func configureUI(){
        self.view.backgroundColor = UIColor.colorWithRGB(r: 231, g: 235, b: 239)
        
        self.view.addSubview(feedAndFilterView)
        feedAndFilterView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setFeedCollectionView(){
        let layout = PinterestLayout()
        layout.delegate = self
        feedAndFilterView.feedView.feedCollectionView.collectionViewLayout = layout
        
        feedAndFilterView.feedView.feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "feedCell")
        
        addRefreshControl()
    }
    
    private func configureNavigationBarItem(){
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: announceButton))
        barButtonItems.append(UIBarButtonItem(customView: showBookMarkButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
    
    private func addRefreshControl(){
        feedAndFilterView.feedView.feedCollectionView.refreshControl = feedRefreshControl
        feedRefreshControl.endRefreshing()
    }
    
    public init(reactor: FeedReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedViewController: View{
    
    public func bind(reactor: FeedReactor) {
        
        reactor.action.onNext(.refresh)
        
        self.dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FeedModel>>(configureCell: { a, collectionView, indexPath, feed in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCollectionViewCell
            cell.disposeBag = DisposeBag()
            cell.configureModel(model: feed)
            cell.bookmarkButton.rx
                .tap
                .map{ _ in
                    if cell.bookmarkButton.isSelected{
                        return Reactor.Action.deleteBookmark(feed.postId, indexPath.item)
                    }else{
                        return Reactor.Action.makeBookmark(BookmarkRequestDTO(postNo: feed.postId), indexPath.item)
                    }
                }.bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            return cell
        })

        reactor.state
            .map{[AnimatableSectionModel(model: "feedModel", items: $0.feeds)]}
            .bind(to: self.feedAndFilterView.feedView.feedCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.feeds }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.feedAndFilterView.feedView.feedCollectionView.collectionViewLayout.invalidateLayout()
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
        
        self.feedAndFilterView.feedView.feedCollectionView.rx.itemSelected
            .bind{ [weak self] indexPath in
                guard let self = self else { return }
                let model = self.dataSource[indexPath]
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showFeedDetail(viewController: self, postId: model.postId)
            }.disposed(by: self.disposeBag)
        
        self.feedAndFilterView.feedView.feedCollectionView.rx.contentOffset
            .map{$0.y}
            .distinctUntilChanged()
            .filter{ [weak self] offset in
                guard let self = self else { return false }
                return offset + self.feedAndFilterView.feedView.feedCollectionView.frame.size.height + 300 > self.feedAndFilterView.feedView.feedCollectionView.contentSize.height
            }.map{ _ in Reactor.Action.fetchFeeds }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        showBookMarkButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showBookmarkedFeed(viewController: self)
            }.disposed(by: self.disposeBag)
        
        announceButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showAnnounce()
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.sortState.title}
            .bind{ [weak self] title in
                guard let self = self else { return }
                self.feedAndFilterView.feedFilterView.sortButton.configuration?.attributedTitle = .init(title, attributes: .init([.font: UIFont.CaptionRegular, .foregroundColor: UIColor.BaseBlack]))
            }.disposed(by: self.disposeBag)
        
        feedAndFilterView.feedFilterView.sortButton.rx
            .tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.showSortFilter(viewController: self, sortState: reactor.currentState.sortState)
            }.disposed(by: self.disposeBag)
        
//        reactor.state.map{$0.distanceState.title}
//            .bind{[weak self] title in
//                guard let self = self else { return }
//                self.feedAndFilterView.feedFilterView.distanceButton.configuration?.attributedTitle = .init(title, attributes: .init([.font: UIFont.CaptionRegular, .foregroundColor: UIColor.BaseBlack]))
//            }.disposed(by: self.disposeBag)
        
//        feedAndFilterView.feedFilterView.distanceButton.rx
//            .tap
//            .bind{ [weak self] _ in
//                guard let self = self else { return }
//                self.coordinator?.showDistanceFilter(viewController: self, distanceState: reactor.currentState.distanceState)
//            }.disposed(by: self.disposeBag)
        
        
        Observable.combineLatest(
            [reactor.state.map { $0.isRefreshing },
             reactor.state.map { $0.feeds.isEmpty }])
        .distinctUntilChanged()
        .skip(1)
        .filter{ !$0[0] && !$0[1] }
        .bind{ [weak self] _ in
            guard let self = self else { return }
            self.feedAndFilterView.feedView.feedCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
        }.disposed(by: self.disposeBag)
    }
}

extension FeedViewController: PinterestLayoutDelegate {
    public func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let model = self.dataSource[indexPath]
        return model.imageUrl == nil ? collectionView.bounds.height / 3 : collectionView.bounds.height / 2
    }
}

extension FeedViewController: FeedDetailViewControllerDelegate{
    public func deleteFeed(postId: Int) {
        reactor?.action.onNext(.deleteFeed(postId))
    }
    
    public func editedFeed(postId: Int) {
        reactor?.action.onNext(.refresh)
    }
    
    public func bookmarkedFeed(postId: Int) {
        reactor?.action.onNext(.updateBookmark(postId))
    }
}

extension FeedViewController: FeedWithOptionViewControllerDelgate{
    public func updatedBookmarkFeed(postId: Int){
        reactor?.action.onNext(.updateBookmark(postId))
    }
}

extension FeedViewController: DistanceFilterViewControllerDelegate{
    public func updatedDistanceState(distanceState: DistanceFilter) {
//        reactor?.action.onNext(.updateDistanceFilter(distanceState))
        reactor?.action.onNext(.refresh)
    }
}

extension FeedViewController: SortfilterViewControllerDelegate{
    public func updatedSortState(sortState: SortFilter) {
        reactor?.action.onNext(.updateSortFilter(sortState))
        reactor?.action.onNext(.refresh)
    }
}
