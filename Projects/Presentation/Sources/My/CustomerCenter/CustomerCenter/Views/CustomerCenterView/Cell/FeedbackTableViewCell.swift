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
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .black
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        return label
    }()
    
    private lazy var stateBadge: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0))
        label.clipsToBounds = true
        label.backgroundColor = .Secondary500
        label.textColor = .BaseWhite
        label.font = .CaptionBold
        return label
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
        self.addSubview(categoryLabel)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        self.addSubview(stateBadge)
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.lessThanOrEqualTo(stateBadge.snp.left).offset(-20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        stateBadge.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureModel(feedbackModel: FeedbackModel){
        categoryLabel.text = feedbackModel.category.title
        titleLabel.text = feedbackModel.title
        dateLabel.text = Date().formatFeedbackCreateDate(dateString: feedbackModel.createDate)
        if feedbackModel.hasReply{
            stateBadge.text = "문의 등록"
        }else{
            stateBadge.text = "답변 완료"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stateBadge.layer.cornerRadius = self.stateBadge.frame.height / 2
    }
}
