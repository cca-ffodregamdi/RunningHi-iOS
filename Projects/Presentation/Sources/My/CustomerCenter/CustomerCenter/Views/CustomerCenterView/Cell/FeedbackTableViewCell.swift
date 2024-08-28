//
//  FeedbackTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 7/20/24.
//

import UIKit
import Common
import SnapKit
import Domain

class FeedbackTableViewCell: UITableViewCell {
    
    static let identifier: String = "FeedbackCell"
    
    private lazy var stateBadge: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0))
        label.clipsToBounds = true
        label.backgroundColor = .Secondary500
        label.textColor = .BaseWhite
        label.font = .CaptionBold
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
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Regular
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
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var categoryCreateDateBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals300
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    private lazy var chevronRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.chevronRightOutline.image
        return imageView
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
        categoryLabel.text = ""
        titleLabel.text = ""
        dateLabel.text = ""
        stateBadge.text = ""
    }
    
    private func configureUI(){
        self.selectionStyle = .none
        
        [stateBadge, questionMarkLabel, titleLabel, contentLabel, categoryCreateDateStackView, chevronRightImageView].forEach {
            self.addSubview($0)
        }
        
        [categoryLabel, categoryCreateDateBreakLine, dateLabel].forEach {
            self.categoryCreateDateStackView.addArrangedSubview($0)
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
            make.right.lessThanOrEqualTo(chevronRightImageView.snp.left).offset(-20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(questionMarkLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.right.lessThanOrEqualTo(chevronRightImageView.snp.left).offset(-20)
        }
        
        categoryCreateDateStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(20)
            make.right.lessThanOrEqualTo(chevronRightImageView.snp.left).offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        categoryCreateDateBreakLine.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        chevronRightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureModel(feedbackModel: FeedbackModel){
        categoryLabel.text = feedbackModel.category.title
        titleLabel.text = feedbackModel.title
        contentLabel.text = feedbackModel.content
        dateLabel.text = Date.formatDateForFeedback(date: feedbackModel.createDate)
        if feedbackModel.hasReply{
            stateBadge.text = "답변 완료"
            stateBadge.backgroundColor = .Primary
        }else{
            stateBadge.text = "문의 등록"
            stateBadge.backgroundColor = .Secondary500
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stateBadge.layer.cornerRadius = self.stateBadge.frame.height / 2
    }
}
