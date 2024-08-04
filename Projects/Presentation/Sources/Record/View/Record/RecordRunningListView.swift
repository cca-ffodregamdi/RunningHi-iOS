//
//  RecordRunningListView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit

class RecordRunningListView: UIView {
    
    //MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 운동 기록"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(RecordRunningListTableViewCell.self, forCellReuseIdentifier: RecordRunningListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        return tableView
    }()
    
    private lazy var noneView: UIView = {
        let view = UIView()
        view.backgroundColor = .Secondary100
        view.isHidden = true
        return view
    }()
    
    private lazy var noneLabel: UIView = {
        let label = UILabel()
        label.text = "달리기 기록이 없습니다."
        label.font = .Body2Regular
        label.textColor = .Neutrals700
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .Secondary100
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(RecordView.horizontalPadding)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(RecordView.horizontalPadding)
            make.height.equalTo(10)
        }
        
        addSubview(noneView)
        noneView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(100)
        }
        
        noneView.addSubview(noneLabel)
        noneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.center.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func setNoneView(_ isNoneData: Bool) {
        noneView.isHidden = !isNoneData
    }
}
