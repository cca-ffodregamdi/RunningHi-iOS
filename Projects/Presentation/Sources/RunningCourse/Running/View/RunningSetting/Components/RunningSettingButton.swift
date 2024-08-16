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
        titleLabel?.font = .Body1Regular
        
        layer.cornerRadius = 20
        
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(85)
        }
        
        setActive(isActive)
    }
    
    //MARK: - Helpers
    
    func setActive(_ isActive: Bool) {
        setTitleColor(isActive ? .white : .Neutrals300, for: .normal)
        backgroundColor = isActive ? .Primary : .Neutrals100
    }
}
