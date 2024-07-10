//
//  RunningResultButton.swift
//  Presentation
//
//  Created by najin on 7/9/24.
//

import UIKit

class RunningResultButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(title: String, isActive: Bool) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(isActive ? .white : .Primary, for: .normal)
        titleLabel?.font = .Body1Regular
        backgroundColor = isActive ? .Primary : .white
        
        layer.borderColor = UIColor.Primary.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 27
        
        self.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
    }
}
