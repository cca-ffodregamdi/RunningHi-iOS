//
//  EditFeedViewController.swift
//  Presentation
//
//  Created by 유현진 on 6/26/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay
import Domain
import CoreLocation

final public class EditFeedViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: FeedCoordinatorInterface?
    
    private var postNo: Int?
    
    public var disposeBag = DisposeBag()
    
    private lazy var feedEditView: FeedEditView = {
        return FeedEditView()
    }()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: EditFeedReactor, postNo: Int){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.postNo = postNo
    }
    
    deinit {
        print("deinit RecordFeedViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureNavigationBar() {
        self.title = "새 게시글"
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeAction))
        self.navigationItem.rightBarButtonItem?.tintColor = .Neutrals300
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(feedEditView)
        
        feedEditView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeAction() {
        if let postNo = postNo {
            reactor?.action.onNext(.createRunningFeed(EditFeedModel(postNo: postNo,
                                                                    postContent: feedEditView.contentTextView.text,
                                                                    mainData: reactor?.currentState.representType ?? .none,
                                                                    imageUrl: "")))
        }
    }
}

// MARK: - Binding

extension EditFeedViewController: View {
    
    public func bind(reactor: EditFeedReactor) {
        bindingView(reactor: reactor)
        bindingButtonAction(reactor: reactor)
    }
    
    private func bindingView(reactor: EditFeedReactor) {
        reactor.state
            .compactMap{$0.isFinishCreateRunningFeed}
            .distinctUntilChanged()
            .bind{ [weak self] type in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingButtonAction(reactor: EditFeedReactor) {
        let represent1Tap = feedEditView.representDistanceButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.distance) }

        let represent2Tap = feedEditView.representTimeButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.time) }
        
        let represent3Tap = feedEditView.representPaceButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.pace) }
        
        let represent4Tap = feedEditView.representKcalButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.kcal) }
        
        let represent5Tap = feedEditView.representNoneButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.none) }

        Observable.merge(represent1Tap, represent2Tap, represent3Tap, represent4Tap, represent5Tap)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .compactMap{$0.representType}
            .distinctUntilChanged()
            .bind{ [weak self] type in
                guard let self = self else { return }
                feedEditView.setRepresentType(type: type)
            }.disposed(by: self.disposeBag)
    }
}
