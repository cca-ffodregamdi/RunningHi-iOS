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
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "feedCell")
        collectionView.register(BFeedCollectionViewCell.self, forCellWithReuseIdentifier: "BfeedCell")
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
        
        
        self.feedCollectionView.rx.setDelegate(self)
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
                self.coordinator?.showFeedDetail(postId: model.postId)
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
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.dataSource[indexPath]
        if model.imageUrl == nil{
            return CGSize(width: (collectionView.bounds.width - 38) / 2, height: (collectionView.bounds.height - 38) / 3)
        }else{
            return CGSize(width: (collectionView.bounds.width - 38) / 2, height: (collectionView.bounds.height - 38) / 2)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 15, bottom: 15, right: 15)
    }
}
