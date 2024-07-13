//
//  EditCommentViewController.swift
//  Presentation
//
//  Created by 유현진 on 7/13/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import Domain
import Common

public protocol EditCommentViewControllerDelegate: AnyObject{
    func editComment()
}

public class EditCommentViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public weak var delegate: EditCommentViewControllerDelegate?
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColor.colorWithRGB(r: 10, g: 10, b: 11)
        return textView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textView.resignFirstResponder()
    }
    
    private func configureUI(){
        self.view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
        }
    }
    
    public init(reactor: EditCommentReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBar(){
        self.title = "댓글 수정"
        let barButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
}

extension EditCommentViewController: View{
    public func bind(reactor: EditCommentReactor) {
        reactor.state.map{$0.commentModel.content}
            .bind(to: textView.rx.text)
            .disposed(by: self.disposeBag)
        
        editButton.rx
            .tap
            .compactMap{ [weak self] _ in
                guard let self = self else { return nil }
                self.textView.resignFirstResponder()
                return Reactor.Action.editComment(EditCommentRequestDTO(commentContent: self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)))
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        textView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind{ [weak self] _ in
                guard let self = self else { return }
                if self.textView.isFirstResponder{
                    self.textView.resignFirstResponder()
                }else{
                    self.textView.becomeFirstResponder()
                }
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isEdited}
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.editComment()
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
        
        
    }
}
