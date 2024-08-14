//
//  RunningSettingButton.swift
//  Presentation
//
//  Created by najin on 8/5/24.
//

import UIKit

class RunningSettingButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(title: String, isActive: Bool) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(isActive ? .white : .Neutrals300, for: .normal)
        titleLabel?.font = .Body1Regular
        backgroundColor = isActive ? .Primary : .Neutrals100
        
        layer.cornerRadius = 20
        
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(85)
        }
    }
}
