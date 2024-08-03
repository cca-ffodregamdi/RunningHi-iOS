//
//  SortFilterView.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import UIKit
import SnapKit
import Common

class SortFilterView: UIView {
        
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "정렬"
        label.textColor = .black
        label.font = .Subhead
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setImage(CommonAsset.xOutline.image, for: .normal)
        return button
    }()
    
    lazy var sortFilterTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(SortFilterTableViewCell.self, forCellReuseIdentifier: SortFilterTableViewCell.identitier)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        
        self.addSubview(sortFilterTableView)
        self.addSubview(titleLabel)
        self.addSubview(cancelButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }
        
        sortFilterTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
