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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        configureNavigationBarItem()
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
        
        recordView.snp.makeConstraints { make in
            make.top.equalTo(postView.snp.bottom).offset(8)
            make.left.right.width.equalToSuperview()
        }
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(recordView.snp.bottom).offset(8)
            make.left.right.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        commentInputView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    private func touchUpCommentOptionButton(isOwner: Bool?, commentModel: CommentModel){
        guard let reactor = reactor else { return }
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editComment = UIAlertAction(title: "수정", style: .default)
        
        let deleteComment = UIAlertAction(title: "삭제", style: .default) { [weak self] _ in
            let deleteAlertController = UIAlertController(title: "댓글 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
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
        
        if isOwner{
            actionSheetController.addAction(editComment)
            actionSheetController.addAction(deleteComment)
        }else{
            actionSheetController.addAction(reportComment)
        }
        actionSheetController.addAction(cancel)
        self.present(actionSheetController, animated: true)
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
                guard let size = size else {return}
                self?.commentTableView.snp.updateConstraints({ make in
                    make.height.equalTo(size.height)
                })
            }.disposed(by: self.disposeBag)
        
        commentInputView.sendButton.rx
            .tap
            .map{ [unowned self] in
                Reactor.Action.writeComment(WriteCommentReqesutDTO(postId: reactor.currentState.postId, content: commentInputView.getCommentText()))
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
            .map{ _ in
                if reactor.currentState.isBookmark{
                    return Reactor.Action.deleteBookmark(reactor.currentState.postId)
                }else{
                    return Reactor.Action.makeBookmark(BookmarkRequestDTO(postNo: reactor.currentState.postId))
                }
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        scrollView.rx.contentOffset
            .map{$0.y}
            .distinctUntilChanged()
            .filter{ [weak self] offset in
                guard let self = self else { return false }
                return offset + self.scrollView.frame.size.height + 100 > self.scrollView.contentSize.height
            }.map{ _ in Reactor.Action.fetchComment}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    
        
        self.commentTableView.rx.setDelegate(self)
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

