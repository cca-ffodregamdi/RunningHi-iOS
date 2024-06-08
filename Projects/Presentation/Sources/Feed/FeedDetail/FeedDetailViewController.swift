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
        return scrollView
    }()
    
    private lazy var postView: PostView = {
       return PostView()
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
    }
    
    public init(reactor: FeedDetailReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBarItem(){
        self.navigationController?.navigationBar.tintColor = .black
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: bookmarkButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureUI(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(postView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        postView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}

extension FeedDetailViewController: View{

    public func bind(reactor: FeedDetailReactor) {
        reactor.action.onNext(.fetchPost)
        
        reactor.state.compactMap{$0.postModel}
            .bind{ [weak self] model in
                self?.postView.configureModel(model: model)
            }.disposed(by: self.disposeBag)
    }
}
