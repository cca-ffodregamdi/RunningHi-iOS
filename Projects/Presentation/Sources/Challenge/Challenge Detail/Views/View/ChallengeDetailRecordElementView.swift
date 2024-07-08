//
//  ChallengeDetailRecordElementView.swift
//  Presentation
//
//  Created by 유현진 on 7/5/24.
//

import UIKit
import SnapKit
import Common

final class ChallengeDetailRecordElementView: UIView {
    
    private lazy var elementTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155)
        return label
    }()
    
    private lazy var elementValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.colorWithRGB(r: 13, g: 13, b: 13)
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
        self.addSubview(elementTitleLabel)
        self.addSubview(elementValueLabel)
        
        elementTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        elementValueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureModel(title: String, value: String){
        elementTitleLabel.text = title
        elementValueLabel.text = value
    }
}
