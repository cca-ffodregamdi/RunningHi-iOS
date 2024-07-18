//
//  NoticeView.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import Common
import SnapKit

final class NoticeView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var noticeHeaderView: NoticeHeaderView = {
        return NoticeHeaderView()
    }()
    
    lazy var noticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: "noticeCell")
        tableView.rowHeight = UITableView.automaticDimension
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
        self.backgroundColor = .systemBackground
        self.addSubview(scrollView)
        [noticeHeaderView, noticeTableView].forEach{
            scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noticeHeaderView.snp.makeConstraints { make in
            make.top.width.left.right.equalToSuperview()
        }
        
        noticeTableView.snp.makeConstraints { make in
            make.top.equalTo(noticeHeaderView.snp.bottom)
            make.width.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
