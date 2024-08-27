//
//  CustomerCenterView.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import SnapKit
import Common

final class CustomerCenterView: UIView {
    
    lazy var headerButtonView: CustomerCenterHeaderButtonView = {
        return CustomerCenterHeaderButtonView()
    }()
    
    lazy var customerCenterTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: FAQTableViewCell.identifier)
        tableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.identifier)
        return tableView
    }()
    
    lazy var createFeedbackButton: UIButton = {
        let button = UIButton()
        button.setTitle("새 문의 작성", for: .normal)
        button.backgroundColor = .Primary
        button.isHidden = true
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
        self.addSubview(headerButtonView)
        self.addSubview(customerCenterTableView)
        self.addSubview(createFeedbackButton)
        
        headerButtonView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        customerCenterTableView.snp.makeConstraints { make in
            make.top.equalTo(headerButtonView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        createFeedbackButton.snp.makeConstraints { make in
            make.top.equalTo(customerCenterTableView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createFeedbackButton.layer.cornerRadius = createFeedbackButton.frame.height / 2
    }
    
    func isHiddenCreateFeedbackButton(mode: CustomerCenterMode){
        switch mode{
        case .FAQ: 
            createFeedbackButton.isHidden = true
            createFeedbackButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        case .Feedback:
            createFeedbackButton.isHidden = false
            createFeedbackButton.snp.updateConstraints { make in
                make.height.equalTo(54)
            }
        }
    }
}
