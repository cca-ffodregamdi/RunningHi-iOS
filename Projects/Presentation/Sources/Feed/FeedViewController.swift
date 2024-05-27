//
//  HomeViewController.swift
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

final class FeedViewController: UIViewController{
    
    
    // MARK: Properties
    var disposeBag: DisposeBag = DisposeBag()
    
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
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "feedCell")
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
          
        configureUI()
        configureNavigationBarItem()
    }
    
    deinit{
        print("deinit HomeViewController")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        
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
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.reactor = FeedReactor() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedViewController: View{
    
    func bind(reactor: FeedReactor) {
        Observable.just(Reactor.Action.fetchFeeds)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedModel>>(configureCell: { a, collectionView, indexPath, feed in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCollectionViewCell
            cell.configureModel(model: feed)
            return cell
        })
        
        reactor.state
            .map{[SectionModel(model: "feeds", items: $0.feeds)]}
            .bind(to: self.feedCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.feedCollectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 400)
    }
}
