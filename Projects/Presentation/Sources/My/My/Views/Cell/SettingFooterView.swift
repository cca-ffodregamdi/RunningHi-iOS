//
//  SettingFooterView.swift
//  Presentation
//
//  Created by 유현진 on 8/19/24.
//

import UIKit
import Common
import SnapKit

class SettingFooterView: UITableViewHeaderFooterView {

    static let identifier: String = "settingFooterView"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .clear
        self.addSubview(containerView)
        self.containerView.addSubview(versionInfoLabel)
        self.containerView.addSubview(versionLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        versionInfoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(20)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    func configureModel(version: String){
        versionLabel.text = version
    }
}
