//
//  AccessView.swift
//  Presentation
//
//  Created by 유현진 on 8/6/24.
//

import UIKit
import SnapKit
import Common

class AccessView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용을 위해\n이용 약관 동의가 필요합니다"
        label.font = .Title2
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var accessTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AccessTableViewCell.self, forCellReuseIdentifier: AccessTableViewCell.identifier)
        tableView.register(AccessFooterView.self, forHeaderFooterViewReuseIdentifier: AccessFooterView.identifiter)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.BaseWhite, for: .normal)
        button.setTitleColor(.Neutrals300, for: .disabled)
        button.backgroundColor = .Neutrals100
        button.isEnabled = false
        return button
    }()
    
    init(){
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .systemBackground
        
        self.addSubview(titleLabel)
        self.addSubview(accessTableView)
        self.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(3)
            make.left.equalToSuperview().offset(20)
        }
        
        accessTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func updateNextButtonUI(bool: Bool){
        if bool{
            nextButton.backgroundColor = .Primary
        }else{
            nextButton.backgroundColor = .Neutrals100
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }
}
