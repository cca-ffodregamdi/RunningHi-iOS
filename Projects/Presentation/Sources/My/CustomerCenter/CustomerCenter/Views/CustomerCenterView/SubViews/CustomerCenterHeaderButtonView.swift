//
//  CustomerCenterHeaderButtonView.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import SnapKit
import Common

final class CustomerCenterHeaderButtonView: UIView {

    private lazy var topButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var faqButton: UIButton = {
        let button = UIButton()
        button.setTitle("자주 묻는 질문", for: .normal)
        button.setTitleColor(.Neutrals500, for: .normal)
        button.setTitleColor(.BaseWhite, for: .selected)
        button.backgroundColor = .Secondary1000
        button.titleLabel?.font = .Body1Bold
        button.clipsToBounds = true
        return button
    }()
    
    lazy var feedbackButton: UIButton = {
        let button = UIButton()
        button.setTitle("1:1 문의", for: .normal)
        button.setTitleColor(.Neutrals500, for: .normal)
        button.setTitleColor(.BaseWhite, for: .selected)
        button.backgroundColor = .BaseWhite
        button.titleLabel?.font = .Body1Regular
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        [faqButton, feedbackButton].forEach{
            topButtonStackView.addArrangedSubview($0)
        }
        self.addSubview(topButtonStackView)
        
        topButtonStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.edges.equalToSuperview()
        }
    }
    
    func toggleButton(mode: CustomerCenterMode){
        switch mode{
        case .FAQ:
            faqButton.isSelected = true
            feedbackButton.isSelected = false
            faqButton.backgroundColor = .Secondary1000
            faqButton.titleLabel?.font = .Body1Bold
            feedbackButton.backgroundColor = .BaseWhite
            feedbackButton.titleLabel?.font = .Body1Regular
        case .Feedback:
            feedbackButton.isSelected = true
            faqButton.isSelected = false
            feedbackButton.backgroundColor = .Secondary1000
            feedbackButton.titleLabel?.font = .Body1Bold
            faqButton.backgroundColor = .BaseWhite
            faqButton.titleLabel?.font = .Body1Regular            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded() 
        faqButton.layer.cornerRadius = faqButton.frame.height/2
        feedbackButton.layer.cornerRadius = feedbackButton.frame.height/2
    }
}
