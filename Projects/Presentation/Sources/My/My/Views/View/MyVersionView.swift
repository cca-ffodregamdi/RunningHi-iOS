//
//  MyVersionView.swift
//  Presentation
//
//  Created by 유현진 on 8/19/24.
//

import UIKit
import SnapKit
import Common

class MyVersionView: UIView {
    
    private lazy var versionInfoLabel: UILabel = {
        var label = UILabel()
        label.text = "버전 정보"
        label.font = .Body2Regular
        label.textColor = .Neutrals500
        return label
    }()

    private lazy var versionLabel: UILabel = {
        var label = UILabel()
        label.font = .Body2Regular
        label.textColor = .Neutrals500
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .clear
        
        self.addSubview(versionInfoLabel)
        self.addSubview(versionLabel)
        
        versionInfoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(40)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(40)
        }
    }
    
    private func configureModel(){
        if let dictionary = Bundle.main.infoDictionary{
            if let version = dictionary["CFBundleShortVersionString"] as? String{
                versionLabel.text = "v\(version)"
            }
        }
    }
}
