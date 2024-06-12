//
//  FeedDetailViewController.swift
//  Presentation
//
//  Created by 유현진 on 6/8/24.
//

import UIKit
import SnapKit
import Common
import ReactorKit
import RxDataSources
import Domain
import RxSwift
import RxCocoa

final public class FeedDetailViewController: UIViewController {
    
    // MARK: Properties
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: FeedCoordinatorInterface?
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bookmarkOutline.image, for: .normal)
        button.setImage(CommonAsset.bookmarkFilled.image, for: .selected)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return scrollView
    }()
    
    private lazy var postView: PostView = {
        return PostView()
    }()
    
    private lazy var recordView: FeedDetailRecordView = {
        return FeedDetailRecordView()
    }()
    
    private lazy var commentTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        return tableView
    }()
    
    // MARK: LifeCyecle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        configureNavigationBarItem()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    public init(reactor: FeedDetailReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBarItem(){
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: bookmarkButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(postView)
        self.scrollView.addSubview(recordView)
        self.scrollView.addSubview(commentTableView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        postView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        recordView.snp.makeConstraints { make in
            make.top.equalTo(postView.snp.bottom).offset(8)
            make.left.right.width.equalToSuperview()
        }
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(recordView.snp.bottom).offset(8)
            make.left.right.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension FeedDetailViewController: View{
    
    public func bind(reactor: FeedDetailReactor) {
        reactor.action.onNext(.fetchPost)
        reactor.action.onNext(.fetchComment)
        
        reactor.state.compactMap{$0.postModel}
            .bind{ [weak self] model in
                self?.postView.configureModel(model: model)
                self?.recordView.configureModel(time: model.time, distance: model.distance, meanPace: model.meanPace, kcal: model.kcal)
            }.disposed(by: self.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CommentModel>> (configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
            cell.configureModel(model: item)
            return cell
        }, titleForHeaderInSection: { dataSource, indexPath in
            return "댓글 \(dataSource.sectionModels.count)"
        })
        
        reactor.state
            .map{[SectionModel(model: "commentModel", items: $0.commentModels)]}
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        commentTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size else {return}
                self?.commentTableView.snp.updateConstraints({ make in
                    make.height.equalTo(size.height)
                })
            }.disposed(by: self.disposeBag)
    }
}
