//
//  MyView.swift
//  Presentation
//
//  Created by 유현진 on 8/16/24.
//

import UIKit
import SnapKit
import Common

class MyView: UIView {

    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var myProfileHeaderView: MyProfileHeaderView = {
        return MyProfileHeaderView()
    }()
    
    lazy var settingTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.register(SettingFooterView.self, forHeaderFooterViewReuseIdentifier: SettingFooterView.identifier)
        tableView.isScrollEnabled = false
        tableView.rowHeight = 56
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
        self.backgroundColor = .clear
        self.addSubview(scrollView)
        self.scrollView.addSubview(myProfileHeaderView)
        self.scrollView.addSubview(settingTableView)
        
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.myProfileHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        self.settingTableView.snp.makeConstraints { make in
            make.top.equalTo(self.myProfileHeaderView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(settingTableView.contentSize.height)
        }
    }
}
