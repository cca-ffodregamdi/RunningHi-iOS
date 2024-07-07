//
//  RunningPopupButton.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit

class RunningPopupButton: UIButton {

    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        self.setTitle(title, for: .normal)
        
        self.layer.cornerRadius = 24
        self.backgroundColor = .Secondary100
        self.titleLabel?.font = .Body1Regular
        self.setTitleColor(.black, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
