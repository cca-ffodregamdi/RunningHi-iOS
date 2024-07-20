//
//  CustomerCenterTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 7/20/24.
//

import UIKit
import Common
import SnapKit
import Domain

class FAQTableViewCell: UITableViewCell {
    
    static let identifier: String = "FAQCell"
    
    var isExpanded: Bool = false {
        didSet {
            answerTextView.isHidden = !isExpanded
            toggleArrowImageView(isExpanded: isExpanded)
            updateAnswerLabelLayout(isExpanded: isExpanded)
        }
    }

    private lazy var questionMarkLabel: UILabel = {
        let label = UILabel()
        label.text = "Q."
        label.font = .Body1Bold
        label.textColor = .black
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.chevronDownOutline.image
        return imageView
    }()
    
    private lazy var answerTextView: UITextView = {
        let textView = UITextView()
        textView.font = .Body2Regular
        textView.backgroundColor = .Neutrals100
        textView.textColor = .Neutrals700
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.isHidden = true
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        questionLabel.text = ""
        answerTextView.text = ""
        self.isExpanded = false
    }
    
    private func configureUI(){
        self.selectionStyle = .none
        
        self.addSubview(questionMarkLabel)
        self.addSubview(questionLabel)
        self.addSubview(arrowImageView)
        self.addSubview(answerTextView)
        
        questionMarkLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(questionMarkLabel.snp.right).offset(20)
            make.right.lessThanOrEqualTo(arrowImageView.snp.left).offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }
        
        answerTextView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
    
    private func toggleArrowImageView(isExpanded: Bool){
        if isExpanded{
            arrowImageView.image = CommonAsset.chevronUpOutline.image
        }else{
            arrowImageView.image = CommonAsset.chevronDownOutline.image
        }
    }
    
    private func updateAnswerLabelLayout(isExpanded: Bool){
        if isExpanded{
            answerTextView.snp.remakeConstraints { make in
                make.top.equalTo(questionLabel.snp.bottom).offset(20)
                make.left.right.equalToSuperview().inset(20)
                make.bottom.equalToSuperview()
            }
        }else{
            answerTextView.snp.remakeConstraints { make in
                make.top.equalTo(questionLabel.snp.bottom).offset(20)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(0)
                make.bottom.equalToSuperview()
            }
        }
        self.layoutIfNeeded()
    }
    
    func configureModel(faqModel: FAQModel, isExpanded: Bool){
        questionLabel.text = faqModel.question
        answerTextView.text = faqModel.answer
        self.isExpanded = isExpanded
    }
}
