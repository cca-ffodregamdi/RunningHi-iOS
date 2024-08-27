//
//  FeedbackDetailView.swift
//  Presentation
//
//  Created by 유현진 on 8/26/24.
//

import UIKit
import Common
import SnapKit
import Domain

class FeedbackDetailView: UIView {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var stateBadge: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0))
        label.clipsToBounds = true
        label.backgroundColor = .Secondary500
        label.textColor = .BaseWhite
        label.font = .CaptionBold
        label.text = "답변 문의"
        return label
    }()
    
    private lazy var questionMarkLabel: UILabel = {
        let label = UILabel()
        label.text = "Q."
        label.font = .Body1Bold
        label.textColor = .black
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .black
        return label
    }()
    
    private lazy var categoryCreateDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    private lazy var categoryCreateDateBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals300
        return view
    }()
    
    private lazy var createDateLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    private lazy var headerBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals300
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Regular
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var answerBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals300
        return view
    }()
    
    private lazy var answerView: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals200
        return view
    }()
    
    private lazy var answerMarkLabel: UILabel = {
        let label = UILabel()
        label.text = "A."
        label.font = .Body1Bold
        label.textColor = .black
        return label
    }()
    
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Regular
        label.textColor = .Neutrals700
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var answerDate: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        
        self.addSubview(scrollView)
        self.scrollView.addSubview(containerView)
        
        [stateBadge, questionMarkLabel, titleLabel, categoryCreateDateStackView, headerBreakLine, contentLabel].forEach {
            containerView.addSubview($0)
        }
        
        [categoryLabel, categoryCreateDateBreakLine, createDateLabel].forEach {
            categoryCreateDateStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stateBadge.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
        }
        
        questionMarkLabel.snp.makeConstraints { make in
            make.top.equalTo(stateBadge.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stateBadge.snp.bottom).offset(8)
            make.left.equalTo(questionMarkLabel.snp.right).offset(5)
        }
        
        categoryCreateDateStackView.snp.makeConstraints { make in
            make.top.equalTo(questionMarkLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(20)
        }
        
        categoryCreateDateBreakLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        headerBreakLine.snp.makeConstraints { make in
            make.top.equalTo(categoryCreateDateStackView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(0.5)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(headerBreakLine.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stateBadge.layoutIfNeeded()
        self.stateBadge.layer.cornerRadius = self.stateBadge.frame.height / 2
    }
    
    func configureModel(model: FeedbackDetailModel){
        titleLabel.text = model.title
        categoryLabel.text = model.category.title
        createDateLabel.text = Date.formatDateForFeedback(date: model.createData)
        contentLabel.text = model.content
        
        if model.hasReply{
            stateBadge.text = "답변 완료"
            stateBadge.backgroundColor = .Primary
        }else{
            stateBadge.text = "문의 등록"
            stateBadge.backgroundColor = .Secondary500
        }
        
        if model.hasReply{ hasReply() }
        
        answerLabel.text = model.reply
        answerDate.text = Date.formatDateForFeedback(date: model.updateDate)
    }
    
    func hasReply(){
        [answerBreakLine, answerView].forEach {
            containerView.addSubview($0)
        }
        
        [answerMarkLabel, answerLabel, answerDate].forEach {
            answerView.addSubview($0)
        }
        
        answerBreakLine.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(1)
        }
        
        answerView.snp.makeConstraints { make in
            make.top.equalTo(answerBreakLine.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
        }
        
        answerMarkLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(answerMarkLabel.snp.right).offset(10)
            make.right.equalTo(answerView.snp.right).offset(-20)
        }
        
        answerDate.snp.makeConstraints { make in
            make.top.equalTo(answerLabel.snp.bottom).offset(8)
            make.left.equalTo(answerLabel.snp.left)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
