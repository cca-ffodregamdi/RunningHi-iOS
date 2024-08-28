//
//  MakeFeedbackView.swift
//  Presentation
//
//  Created by 유현진 on 8/26/24.
//

import UIKit
import Common
import SnapKit

class MakeFeedbackView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var feedBackTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "문의 유형"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    lazy var feedbackDropdownView: FeedbackDropdownView = {
        return FeedbackDropdownView()
    }()
    
    lazy var backgroundShadowView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .BaseBlack
        view.alpha = 0.4
        return view
    }()
    lazy var feedbackTypeDropdownTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.sectionHeaderTopPadding = 0
        tableView.register(FeedbackTypeHeaderView.self, forHeaderFooterViewReuseIdentifier: FeedbackTypeHeaderView.identifier)
        tableView.register(FeedbackTypeTableViewCell.self, forCellReuseIdentifier: FeedbackTypeTableViewCell.identifier)
        tableView.clipsToBounds = true
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.Neutrals500.cgColor
        tableView.layer.cornerRadius = 8
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        return tableView
    }()
    
    private lazy var feedbackTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    lazy var feedbackTitleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.Neutrals500])
       
        textField.font = .Body1Regular
        textField.textColor = .BaseBlack
        textField.clipsToBounds = true
        
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.Neutrals500.cgColor
        textField.layer.cornerRadius = 8
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var feedbackContentLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    lazy var feedbackContentTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        textView.text = "내용을 입력해주세요."
        textView.font = .Body1Regular
        textView.textColor = .Neutrals500
        textView.clipsToBounds = true
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.Neutrals500.cgColor
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        label.text = "문의사항 등록 시 개인정보 수집 및 이용에 동의하는 것으로 간주됩니다."
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("전달", for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = .Neutrals100
        button.isEnabled = false
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
        self.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        [feedBackTypeLabel, feedbackTitleLabel, feedbackDropdownView, feedbackTitleTextField, feedbackContentLabel, feedbackContentTextView, warningLabel, submitButton, backgroundShadowView, feedbackTypeDropdownTableView].forEach{
            self.containerView.addSubview($0)
        }
        
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
        feedBackTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        feedbackDropdownView.snp.makeConstraints { make in
            make.top.equalTo(feedBackTypeLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        backgroundShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        feedbackTypeDropdownTableView.snp.makeConstraints { make in
            make.top.equalTo(feedbackDropdownView.snp.top)
            make.left.equalTo(feedbackDropdownView.snp.left)
            make.right.equalTo(feedbackDropdownView.snp.right)
            make.height.equalTo(feedbackTypeDropdownTableView.contentSize.height)
        }
        
        feedbackTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(feedbackDropdownView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        feedbackTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(feedbackTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        
        feedbackContentLabel.snp.makeConstraints { make in
            make.top.equalTo(feedbackTitleTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        feedbackContentTextView.snp.makeConstraints { make in
            make.top.equalTo(feedbackContentLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(300)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(feedbackContentTextView.snp.bottom).offset(80)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(submitButton.snp.top).offset(-10)
        }
        
        submitButton.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(54)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func isShowFeedbackCategoryTableView(value: Bool){
        backgroundShadowView.isHidden = !value
        feedbackTypeDropdownTableView.isHidden = !value
    }
    
    func editingContentTextView(){
        if feedbackContentTextView.text == "내용을 입력해주세요."{
            feedbackContentTextView.text = ""
            feedbackContentTextView.textColor = .BaseBlack
        }
    }
    
    func isEmptyContentTextView(){
        if feedbackContentTextView.text.isEmpty{
            feedbackContentTextView.text = "내용을 입력해주세요."
            feedbackContentTextView.textColor = .Neutrals500
        }
    }
    
    func isEnableSubmitButton(isEnable: Bool){
        submitButton.isEnabled = isEnable
        if isEnable{
            submitButton.backgroundColor = .Primary
        }else{
            submitButton.backgroundColor = .Neutrals100
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        submitButton.layoutIfNeeded()
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
    }
}
