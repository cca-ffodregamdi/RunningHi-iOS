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
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.adjustmentsOutline.image, for: .normal)
        return button
    }()
    
    private lazy var showBookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bookmarkOutline.image, for: .normal)
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bellOutline.image, for: .normal)
        return button
    }()
    
    private lazy var feedCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        collectionView.backgroundColor = .clear
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "feedCell")
        collectionView.alwaysBounceVertical = true
        return collectionView
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
    }
    
    deinit{
        print("deinit FeedViewController")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureUI(){
        self.view.backgroundColor = UIColor.colorWithRGB(r: 231, g: 235, b: 239)
        
        self.view.addSubview(feedCollectionView)
        
        feedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureNavigationBarItem(){
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: notificationButton))
        barButtonItems.append(UIBarButtonItem(customView: showBookMarkButton))
        barButtonItems.append(UIBarButtonItem(customView: filterButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
    
    private func addRefreshControl(){
        feedCollectionView.refreshControl = feedRefreshControl
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
        Observable.just(Reactor.Action.fetchFeeds)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FeedModel>>(configureCell: { a, collectionView, indexPath, feed in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCollectionViewCell
            
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
            .bind(to: self.feedCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.feeds }
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.feedCollectionView.collectionViewLayout.invalidateLayout()
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
        
        self.feedCollectionView.rx.itemSelected
            .bind{ [weak self] indexPath in
                guard let self = self else { return }
                let model = self.dataSource[indexPath]
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showFeedDetail(viewController: self, postId: model.postId)
            }.disposed(by: self.disposeBag)
        
        self.feedCollectionView.rx.contentOffset
            .map{$0.y}
            .distinctUntilChanged()
            .filter{ [weak self] offset in
                guard let self = self else { return false }
                return offset + self.feedCollectionView.frame.size.height + 100 > self.feedCollectionView.contentSize.height
            }.map{ _ in Reactor.Action.fetchFeeds }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        showBookMarkButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showBookmarkedFeed()
            }.disposed(by: self.disposeBag)
    }
}

extension FeedViewController: FeedDetailViewControllerDelegate{
    public func deleteFeed() {
        reactor?.action.onNext(.refresh)
    }
}

extension FeedViewController: PinterestLayoutDelegate {
    public func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let model = self.dataSource[indexPath]
        return model.imageUrl == nil ? collectionView.bounds.height / 3 : collectionView.bounds.height / 2
    }
}
