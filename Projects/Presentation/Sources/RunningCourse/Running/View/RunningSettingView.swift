//
//  RunningSettingView.swift
//  Presentation
//
//  Created by najin on 8/5/24.
//

import UIKit
import SnapKit
import Domain

class RunningSettingView: UIView {
    
    //MARK: - Configure
    
    private lazy var distanceButton = {
        let button = RunningSettingButton(title: "거리", isActive: true)
        return button
    }()
    
    private lazy var timeButton = {
        let button = RunningSettingButton(title: "시간", isActive: false)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        congifureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        congifureUI()
    }
    
    //MARK: - Configure
    
    private func congifureUI() {
        backgroundColor = .BaseWhite
        
        addSubview(distanceButton)
        addSubview(timeButton)
        
        distanceButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(26)
            make.top.equalToSuperview().inset(51)
        }
        
        timeButton.snp.makeConstraints { make in
            make.left.equalTo(distanceButton.snp.right).offset(9)
            make.top.equalToSuperview().inset(51)
        }
    }
}
