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

public protocol FeedDetailViewControllerDelegate: AnyObject{
    func deleteFeed(postId: Int)
    func editedFeed(postId: Int)
    func bookmarkedFeed(postId: Int)
}

final public class FeedDetailViewController: UIViewController {
    
    // MARK: Properties
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: FeedCoordinatorInterface?
    
    public weak var delegate: FeedDetailViewControllerDelegate?
    
    private var stickyViewHeight: NSLayoutConstraint?
    
    private let stickViewDefaultHeight: CGFloat = UIScreen.main.bounds.height / 3
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.bookmarkOutline.image, for: .normal)
        button.setImage(CommonAsset.bookmarkBlue.image, for: .selected)
        return button
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.dotsVerticalOutline.image, for: .normal)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var stickyImageView: StickyImageView = {
        return StickyImageView(frame: .zero)
    }()
    
    private lazy var postView: PostView = {
        return PostView()
    }()
    
    private lazy var postRecordBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var recordView: FeedDetailRecordView = {
        return FeedDetailRecordView()
    }()
    
    private lazy var recordCommentBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var commentTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.register(CommentHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "commentHeader")
        tableView.register(EmptyCommentFooterView.self, forHeaderFooterViewReuseIdentifier: "commentFooter")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()
    
    private lazy var commentInputView: CommentInputView = {
        return CommentInputView()
    }()
    
    // MARK: LifeCyecle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTouchUpBackground()
    }
    
    deinit{
        print("deinit FeedDetailViewController")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        setTransparentNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        commentInputView.resignResponderTextView()
    }
    
    public init(reactor: FeedDetailReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigationBarButton(isOwner: Bool){
        var barButtonItems: [UIBarButtonItem] = []
        if isOwner{
            barButtonItems.append(UIBarButtonItem(customView: optionButton))
        }else{
            barButtonItems.append(UIBarButtonItem(customView: bookmarkButton))
        }
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(postView)
        self.scrollView.addSubview(postRecordBreakLine)
        self.scrollView.addSubview(recordView)
        self.scrollView.addSubview(recordCommentBreakLine)
        self.scrollView.addSubview(commentTableView)
        self.view.addSubview(commentInputView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(commentInputView.snp.top)
        }
        
        postView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        postRecordBreakLine.snp.makeConstraints { make in
            make.top.equalTo(postView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
        
        recordView.snp.makeConstraints { make in
            make.top.equalTo(postRecordBreakLine.snp.bottom)
            make.left.right.width.equalToSuperview()
        }
        
        recordCommentBreakLine.snp.makeConstraints { make in
            make.top.equalTo(recordView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(recordCommentBreakLine.snp.bottom)
            make.left.right.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        commentInputView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    private func touchUpCommentOptionButton(isOwner: Bool, commentModel: CommentModel){
        guard let reactor = reactor else { return }
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editComment = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.coordinator?.showEditComment(viewController: self, commentModel: commentModel)
        }
        
        let deleteComment = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            let deleteAlertController = UIAlertController(title: "댓글을 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive){ _ in
                reactor.action.onNext(.deleteComment(commentModel))
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            deleteAlertController.addAction(deleteAction)
            deleteAlertController.addAction(cancelAction)
            self?.present(deleteAlertController, animated: true)
        }
        
        let reportComment = UIAlertAction(title: "신고", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.coordinator?.showReportComment(commentId: commentModel.commentId)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        if isOwner {
            actionSheetController.addAction(editComment)
            actionSheetController.addAction(deleteComment)
        }else{
            actionSheetController.addAction(reportComment)
        }
        actionSheetController.addAction(cancel)
        self.present(actionSheetController, animated: true)
    }
    
    private func touchUpNavigationBarOptionButton(){
        guard let reactor = reactor else { return }
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editComment = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.coordinator?.showEditPost(viewController: self, postId: reactor.currentState.postId)
        }
        
        let deleteComment = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            let deleteAlertController = UIAlertController(title: "게시글 삭제", message: "게시글을 삭제하시겠습니까?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive){ _ in
                reactor.action.onNext(.deletePost(reactor.currentState.postId))
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            deleteAlertController.addAction(deleteAction)
            deleteAlertController.addAction(cancelAction)
            self?.present(deleteAlertController, animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        //TODO: njshin 추후 수정기능 추가되면 주석 해제
//        actionSheetController.addAction(editComment)
        actionSheetController.addAction(deleteComment)
        actionSheetController.addAction(cancel)
        self.present(actionSheetController, animated: true)
    }
    
    private func updateStickyImageView(offsetY: CGFloat){
        guard let constraint = stickyViewHeight else { return }
        
        let remainingTopSpacing = abs(offsetY)
        let lowerThanTop = offsetY < 0
        let stopExpandHeaderHeight = offsetY > -stickViewDefaultHeight
        
        if stopExpandHeaderHeight, lowerThanTop {
            // 초기 상태, UIImageView가 지정한 크기만큼 커졌고, 스크롤뷰의 시작점이 최상단보다 아래 존재
            scrollView.contentInset = .init(top: remainingTopSpacing, left: 0, bottom: 0, right: 0)
            constraint.constant = remainingTopSpacing
            view.layoutIfNeeded()
        } else if !lowerThanTop {
            // 스크롤 뷰의 시작점이 최상단보다 위에 존재
            scrollView.contentInset = .zero
            constraint.constant = 0
        } else {
            // 3) 스크롤 뷰의 시작점이 최상단보다 밑에 있고, 스크롤뷰 상단 contentInset이 미리 지정한 stickViewDefaultHeight 보다 큰 경우
            constraint.constant = remainingTopSpacing
        }
    }
    
    private func setTransparentNavigationBar(){
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
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureStickyView(imageUrl: String?){
        guard let url = imageUrl else { return }
        
        if stickyImageView.superview != nil {
            stickyImageView.removeFromSuperview()
        }
        
        self.scrollView.contentInset = .init(top: stickViewDefaultHeight, left: 0, bottom: 0, right: 0)
        self.scrollView.contentOffset = .init(x: 0, y: -stickViewDefaultHeight)
        
        
        self.view.addSubview(stickyImageView)
        self.stickyImageView.setImage(urlString: url)
        
        stickyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.commentInputView.snp.top)
        }
        
        stickyViewHeight = stickyImageView.heightAnchor.constraint(equalToConstant: stickViewDefaultHeight)
        stickyViewHeight?.isActive = true
        
        let tapGesture = UITapGestureRecognizer()
        stickyImageView.addGestureRecognizer(tapGesture)
        stickyImageView.isUserInteractionEnabled = true
        tapGesture.rx.event
            .bind{ [weak self] _ in
                guard let self = self else { return }
                let vc = ThumbnailImageViewController(imageUrl: url)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }.disposed(by: self.disposeBag)
    }
}

extension FeedDetailViewController: View{
    
    public func bind(reactor: FeedDetailReactor) {

        Observable.just(Reactor.Action.fetchPost)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        Observable.just(Reactor.Action.fetchComment)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .compactMap{ $0.postModel }
            .distinctUntilChanged()
            .bind{ [weak self] model in
                guard let self = self else { return }
                self.postView.configureModel(model: model)
                self.recordView.configureModel(difficulty: model.difficulty, time: model.time, distance: model.distance, meanPace: model.meanPace, kcal: model.kcal)
            }.disposed(by: self.disposeBag)
        
        reactor.state.compactMap{$0.postModel?.imageUrl}
            .distinctUntilChanged()
            .bind{ [weak self] imageUrl in
                guard let self = self else { return }
                self.configureStickyView(imageUrl: imageUrl)
            }.disposed(by: self.disposeBag)
        
        reactor.state.compactMap{$0.postModel}
            .map{$0.isOwner}
            .distinctUntilChanged()
            .bind{ [weak self] isOwner in
                guard let self = self else { return }
                self.setNavigationBarButton(isOwner: isOwner)
            }.disposed(by: self.disposeBag)
            
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CommentModel>> (configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
            cell.configureModel(model: item)
            
            cell.optionButton.rx.tap
                .bind{ [weak self] _ in
                    guard let self = self else { return }
                    self.touchUpCommentOptionButton(isOwner: item.isOwner, commentModel: item)
                }.disposed(by: cell.disposeBag)
            return cell
        })
        
        reactor.state
            .map{[SectionModel(model: "commentModel", items: $0.commentModels)]}
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        
        commentTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.commentTableView.snp.updateConstraints({ make in
                    make.height.equalTo(size.height)
                })
            }.disposed(by: self.disposeBag)
        
        commentInputView.sendButton.rx
            .tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .map{ [weak self] in
                Reactor.Action.writeComment(WriteCommentReqesutDTO(postId: reactor.currentState.postId, content: self?.commentInputView.getCommentText() ?? ""))
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{ $0.isWroteComment }
            .filter{ $0 }
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.commentInputView.resetTextViewAndSendButton()
                self.commentInputView.resignResponderTextView()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self.scrollView.setContentOffset(.init(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height), animated: true)
                }
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.isBookmark}
            .bind(to: self.bookmarkButton.rx.isSelected)
            .disposed(by: self.disposeBag)
        
        bookmarkButton.rx
            .tap
            .map{ [weak self] _ in
                self?.delegate?.bookmarkedFeed(postId: reactor.currentState.postId)
                if reactor.currentState.isBookmark{
                    return Reactor.Action.deleteBookmark(reactor.currentState.postId)
                }else{
                    return Reactor.Action.makeBookmark(BookmarkRequestDTO(postNo: reactor.currentState.postId))
                }
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        optionButton.rx
            .tap
            .bind{ [weak self] _ in
                self?.touchUpNavigationBarOptionButton()
            }.disposed(by: self.disposeBag)
        
        scrollView.rx.contentOffset
            .map{$0.y}
            .distinctUntilChanged()
            .bind{ [weak self] offset in
                guard let self = self else { return }
                let isAtBottom = offset + self.scrollView.frame.size.height >= self.scrollView.contentSize.height
                guard !isAtBottom else { return }
                self.updateStickyImageView(offsetY: offset)
            }.disposed(by: self.disposeBag)
        
        self.commentTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.deletedPost}
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.deleteFeed(postId: reactor.currentState.postId)
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.isLike}
            .bind(to: postView.likeButton.rx.isSelected)
            .disposed(by: self.disposeBag)
        
        postView.likeButton.rx
            .tap
            .map{ _ in
                if reactor.currentState.isLike{
                    return Reactor.Action.unLikePost(reactor.currentState.postId)
                }else{
                    return Reactor.Action.likePost(FeedLikeRequestDTO(postNo: reactor.currentState.postId))
                }
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
            
    }
}

extension FeedDetailViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "commentHeader") as! CommentHeaderFooterView
        guard let reactor = reactor else { return nil }
        view.configureModel(title: "댓글 \(reactor.currentState.commentModels.count)")
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 // 충분히 큰 높이 설정
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "commentFooter")
        guard let reactor = reactor else {return nil}
        if reactor.currentState.commentModels.count != 0 { return nil }
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let reactor = reactor else { return 0 }
        if reactor.currentState.commentModels.count != 0 { return 0 }
        return 90
    }
}

extension FeedDetailViewController: EditCommentViewControllerDelegate{
    public func editComment() {
        reactor?.action.onNext(.fetchComment)
    }
}

extension FeedDetailViewController: EditFeedViewControllerDelegate{
    public func updateFeedDetail() {
        reactor?.action.onNext(.fetchPost)
        guard let reactor = reactor else { return }
        delegate?.editedFeed(postId: reactor.currentState.postId)
    }
}
