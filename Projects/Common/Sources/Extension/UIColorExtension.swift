//
//  UIColorExtension.swift
//  Common
//
//  Created by 유현진 on 5/17/24.
//

import UIKit

public extension UIColor{
    
    static func colorWithRGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}
