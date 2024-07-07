//
//  RunningRecordButton.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit

class RunningRecordButton: UIButton {

    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        self.setImage(image, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
