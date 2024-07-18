//
//  ChallengeHeaderView.swift
//  Presentation
//
//  Created by 유현진 on 5/29/24.
//

import UIKit
import SnapKit

class ChallengeHeaderFooterView: UITableViewHeaderFooterView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureModel(title: String){
        self.titleLabel.text = title
    }
}
