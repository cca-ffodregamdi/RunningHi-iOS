//
//  ChallengeCollectionReusableView.swift
//  Presentation
//
//  Created by 유현진 on 8/15/24.
//

import UIKit
import SnapKit
import Common

class ChallengeCollectionReusableView: UICollectionReusableView {
    static let identifier: String = "challengeReusableView"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .Subhead
        label.textColor = .colorWithRGB(r: 130, g: 143, b: 155)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(titleLabel)
        self.addSubview(countLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureModel(title: String, count: Int){
        self.titleLabel.text = title
        self.countLabel.text = "(\(count))"
    }
}
