//
//  SignOutFooterView.swift
//  Presentation
//
//  Created by 유현진 on 8/24/24.
//

import UIKit
import SnapKit
import Common
import RxSwift

class SignOutFooterView: UITableViewHeaderFooterView {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    static let identifier: String = "signOutFooterView"
    
    lazy var answerTextView: UITextView = {
        let textView = UITextView()
        textView.font = .Body2Regular
        textView.backgroundColor = .white
        textView.textColor = .Neutrals500
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.Neutrals500.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        answerTextView.text = ""
        disposeBag = DisposeBag()
    }
    
    private func configureUI(){
        self.contentView.addSubview(answerTextView)
        
        answerTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
