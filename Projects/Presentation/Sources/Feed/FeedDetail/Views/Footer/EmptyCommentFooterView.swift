//
//  EmptyCommentFooterView.swift
//  Presentation
//
//  Created by 유현진 on 6/23/24.
//

import UIKit
import SnapKit

class EmptyCommentFooterView: UITableViewHeaderFooterView {
    
    static let identifier: String = "commentFooterView"
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "가장 먼저 댓글을 남겨보세요."
        label.textColor = .lightGray
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
        self.addSubview(warningLabel)
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
