//
//  PaddingLabel.swift
//  Common
//
//  Created by 유현진 on 7/18/24.
//

import UIKit

public class PaddingLabel: UILabel{
    private var padding: UIEdgeInsets
    
    public init(padding: UIEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        super.init(coder: coder)
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
