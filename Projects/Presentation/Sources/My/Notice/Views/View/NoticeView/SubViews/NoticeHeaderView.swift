//
//  NoticeHeaderView.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import SnapKit
import Common

final class NoticeHeaderView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NOTICE"
        label.font = .Body2Regular
        label.textColor = .Primary500
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이에서 알려드립니다."
        label.font = .Headline
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = UIColor.Primary100
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}
