//
//  FeedbackDetailViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

public class FeedbackDetailViewController: UIViewController {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var feedbackDetailView: FeedbackDetailView = {
        return FeedbackDetailView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    public init(reactor: FeedbackDetailReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(feedbackDetailView)
        
        feedbackDetailView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationBar(){
        self.title = "1:1 문의"
    }
}
extension FeedbackDetailViewController: View{
    public func bind(reactor: FeedbackDetailReactor) {
        reactor.action.onNext(.fetchFeedbackDetail)
        
        reactor.state.compactMap{$0.feedbackDetailModel}
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.feedbackDetailView.configureModel(model: model)
            }).disposed(by: self.disposeBag)
    }
}
