//
//  DifficultyLabel.swift
//  Common
//
//  Created by 유현진 on 7/13/24.
//

import UIKit
import Domain

public class DifficultyLabel: UILabel {

    private var padding = UIEdgeInsets(top: 2.0, left: 6.0, bottom: 2.0, right: 6.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    public func setTitle(difficulty: FeedDetailDifficultyType){
        switch difficulty{
        case .VERYEASY:
            self.textColor = UIColor.colorWithRGB(r: 121, g: 169, b: 36)
            self.backgroundColor = UIColor.colorWithRGB(r: 226, g: 242, b: 196)
            self.text = "매우 쉬움"
        case .EASY:
            self.textColor = UIColor.colorWithRGB(r: 121, g: 169, b: 36)
            self.backgroundColor = UIColor.colorWithRGB(r: 226, g: 242, b: 196)
            self.text = "쉬움"
        case .NORMAL:
            self.textColor = UIColor.colorWithRGB(r: 179, g: 150, b: 0)
            self.backgroundColor = UIColor.colorWithRGB(r: 255, g: 242, b: 170)
            self.text = "보통"
        case .HARD:
            self.textColor = UIColor.colorWithRGB(r: 211, g: 11, b: 0)
            self.backgroundColor = UIColor.colorWithRGB(r: 255, g: 190, b: 186)
            self.text = "어려움"
        case .VERYHARD:
            self.textColor = UIColor.colorWithRGB(r: 211, g: 11, b: 0)
            self.backgroundColor = UIColor.colorWithRGB(r: 255, g: 190, b: 186)
            self.text = "매우 어려움"
        }
    }
}
