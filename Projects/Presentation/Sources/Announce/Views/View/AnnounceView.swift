//
//  AnnounceView.swift
//  Presentation
//
//  Created by 유현진 on 8/5/24.
//

import UIKit
import SnapKit

class AnnounceView: UIView {

    lazy var announceTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(AnnounceTableViewCell.self, forCellReuseIdentifier: AnnounceTableViewCell.identifier)
        return tableView
    }()
    
    init(){
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(announceTableView)
        
        announceTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
