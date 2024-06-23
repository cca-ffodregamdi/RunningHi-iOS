//
//  CommentInputView.swift
//  Presentation
//
//  Created by 유현진 on 6/12/24.
//

import UIKit
import SnapKit
import Common
import RxSwift
import RxCocoa

final class CommentInputView: UIView {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var topBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .systemGray6
        textView.text = "댓글을 입력해 주세요."
        textView.textColor = .lightGray
        textView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        textView.isScrollEnabled = false
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "arrow.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        button.configuration = configuration
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentTextView.layer.cornerRadius = commentTextView.frame.size.width * 0.05
    }
    
    private func configureUI(){
        self.addSubview(topBreakLine)
        self.addSubview(commentTextView)
        self.addSubview(sendButton)
        
        topBreakLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(topBreakLine.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(sendButton.snp.left)
            make.height.equalTo(33)
        }
        
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    func resetTextViewAndSendButton(){
        commentTextView.textColor = .lightGray
        commentTextView.text = "댓글을 입력해 주세요."
        commentTextView.snp.updateConstraints { make in
            make.height.equalTo(33)
        }
        self.layoutIfNeeded()
        self.sendButton.isEnabled = false
    }
    
    func resignResponderTextView(){
        commentTextView.resignFirstResponder()
    }
    
    func getCommentText() -> String{
        return commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func bind(){
        commentTextView.rx.didEndEditing
            .bind{ [weak self] _ in
                guard let self = self else {return}
                if self.commentTextView.text.isEmpty{
                    self.commentTextView.textColor = .lightGray
                    self.commentTextView.text = "댓글을 입력해 주세요."
                }
            }.disposed(by: self.disposeBag)
        
        commentTextView.rx.didBeginEditing
            .bind{ [weak self] _ in
                guard let self = self else {return}
                if self.commentTextView.textColor == .lightGray{
                    self.commentTextView.text = ""
                    self.commentTextView.textColor = .black
                }
            }.disposed(by: self.disposeBag)
        
        commentTextView.rx.didChange
            .bind{ [weak self] _ in
                guard let self = self else {return}
                
                if commentTextView.text.count > 0{
                    sendButton.isEnabled = true
                }else{
                    sendButton.isEnabled = false
                }
                
                let size = CGSize(width: self.frame.width, height: .infinity)
                let estimatedSize = commentTextView.sizeThatFits(size)
               
                self.commentTextView.isScrollEnabled = estimatedSize.height >= 130
                if estimatedSize.height < 130 {
                    self.commentTextView.constraints.forEach { constraint in
                        if constraint.firstAttribute == .height {
                            constraint.constant = estimatedSize.height
                        }
                    }
                }
            }.disposed(by: self.disposeBag)
    }
}
