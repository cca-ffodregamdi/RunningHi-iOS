//
//  MakeFeedbackViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import Common
import Domain

public protocol MakeFeedbackViewControllerDelegate: AnyObject{
    func madeFeedback()
}

public class MakeFeedbackViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public weak var delegate: MakeFeedbackViewControllerDelegate?
    
    private lazy var makeFeedBackView: MakeFeedbackView = {
        return MakeFeedbackView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        hideKeyboardWhenTouchUpBackground()
    }
        
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    public init(reactor: MakeFeedBackReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(makeFeedBackView)
        
        makeFeedBackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
        }
    }
    
    private func configureNavigationBar(){
        self.title = "문의 작성"
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension MakeFeedbackViewController: View{

    public func bind(reactor: MakeFeedBackReactor) {
        
        reactor.state.map{$0.feedbackCategory}
            .bind(to: makeFeedBackView.feedbackTypeDropdownTableView.rx.items(cellIdentifier: FeedbackTypeTableViewCell.identifier, cellType: FeedbackTypeTableViewCell.self)){ [weak self] index, item, cell in
                
                cell.configureModel(type: item.title)
                
                cell.tapGestureRecognizer.rx
                    .event
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        reactor.action.onNext(.selectFeedbackCategory(reactor.currentState.feedbackCategory[index]))
                        self.makeFeedBackView.feedbackDropdownView.configureFeedbackCategoryText(type: reactor.currentState.selectedFeedbackCategory?.title)
                        self.makeFeedBackView.isShowFeedbackCategoryTableView(value: false)
                    }).disposed(by: cell.disposeBag)

            }.disposed(by: self.disposeBag)
        
        makeFeedBackView.feedbackTypeDropdownTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let self = self, let size = size else { return }
                self.makeFeedBackView.feedbackTypeDropdownTableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
        
        makeFeedBackView.feedbackTypeDropdownTableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        
        makeFeedBackView.feedbackDropdownView.tapGestureRecognizer.rx
            .event
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.makeFeedBackView.isShowFeedbackCategoryTableView(value: true)
            }).disposed(by: self.disposeBag)
        
        makeFeedBackView.feedbackContentTextView.rx
            .didBeginEditing
            .subscribe(onNext:{ [weak self] in
                guard let self = self else  { return }
                self.makeFeedBackView.editingContentTextView()
            }).disposed(by: self.disposeBag)
        
        makeFeedBackView.feedbackContentTextView.rx
            .didEndEditing
            .subscribe(onNext:{ [weak self] in
                guard let self = self else  { return }
                self.makeFeedBackView.isEmptyContentTextView()
            }).disposed(by: self.disposeBag)
        
        makeFeedBackView.feedbackTitleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map{Reactor.Action.isExistFeedbackTitle(!$0.isEmpty)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        makeFeedBackView.feedbackContentTextView.rx.text
            .distinctUntilChanged()
            .map{ [weak self] text -> Bool in
                guard let text = text, !text.isEmpty else { return false }
                return self?.makeFeedBackView.feedbackContentTextView.textColor != UIColor.Neutrals500
            }
            .map{Reactor.Action.isExistFeedbackContent($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
            
        Observable.combineLatest(reactor.state.map{$0.selectedFeedbackCategory != nil},
                                 reactor.state.map{$0.isExistFeedbackTitle},
                                 reactor.state.map{$0.isExistFeedbackContent})
        .distinctUntilChanged({$0 == $1})
        .map{$0 && $1 && $2}
        .bind{ [weak self] isEnable in
            guard let self = self else { return }
            self.makeFeedBackView.isEnableSubmitButton(isEnable: isEnable)
        }
        .disposed(by: self.disposeBag)
        
        makeFeedBackView.submitButton.rx
            .tap
            .compactMap{ [weak self] _ in
                guard let self = self else { return nil }
                guard let title = self.makeFeedBackView.feedbackTitleTextField.text else { return nil }
                guard let content = self.makeFeedBackView.feedbackContentTextView.text else { return nil}
                guard let category = reactor.currentState.selectedFeedbackCategory else { return nil }
                return MakeFeedbackRequestModel(title: title,
                                                content: content,
                                                category: category)
            }.map{Reactor.Action.makeFeedback($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.successedMadeFeedback}
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.madeFeedback()
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
            
    }
}

extension MakeFeedbackViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedbackTypeHeaderView.identifier) as? FeedbackTypeHeaderView else { return nil }
        view.tapGestureRecognizer.rx
            .event
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
                reactor?.action.onNext(.resetSelectedFeedbackCategory)
                self.makeFeedBackView.feedbackDropdownView.configureFeedbackCategoryText(type: nil)
                self.makeFeedBackView.isShowFeedbackCategoryTableView(value: false)
            }).disposed(by: self.disposeBag)
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
