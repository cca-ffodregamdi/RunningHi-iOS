//
//  SignOutView.swift
//  Presentation
//
//  Created by 유현진 on 8/24/24.
//

import UIKit
import SnapKit
import Common

class SignOutView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "님,\n어떤 점이 불편하셨나요?"
        label.font = .Title2
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    lazy var signOutTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SignOutTableViewCell.self, forCellReuseIdentifier: SignOutTableViewCell.identifier)
        tableView.register(SignOutFooterView.self, forHeaderFooterViewReuseIdentifier: SignOutFooterView.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        [titleLabel, signOutTableView].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.right.equalToSuperview().inset(20)
        }
        
        signOutTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
