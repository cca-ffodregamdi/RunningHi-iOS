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
    
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  alpha: alpha)
    }
    
    var isDark: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance < 0.5
    }
    
    // Color Palette
    static var BaseWhite: UIColor { return UIColor(hexaRGB: "fafafa") ?? UIColor.white }
    static var BaseBlack: UIColor { return UIColor(hexaRGB: "0a0a0b") ?? UIColor.white }
    static var Primary: UIColor { return UIColor(hexaRGB: "2265tC9") ?? UIColor.white }
    static var Secondary: UIColor { return UIColor(hexaRGB: "AAB9C5") ?? UIColor.white }
    static var Success: UIColor { return UIColor(hexaRGB: "A7D94D") ?? UIColor.white }
    static var Warning: UIColor { return UIColor(hexaRGB: "FFD700") ?? UIColor.white }
    static var Error: UIColor { return UIColor(hexaRGB: "FF3B30") ?? UIColor.white }
    
    // Primary
    static var Primary100: UIColor { return UIColor(hexaRGB: "dde9f9") ?? UIColor.white }
    static var Primary200: UIColor { return UIColor(hexaRGB: "bcd2f4") ?? UIColor.white }
    static var Primary300: UIColor { return UIColor(hexaRGB: "9abcee") ?? UIColor.white }
    static var Primary400: UIColor { return UIColor(hexaRGB: "79a5e8") ?? UIColor.white }
    static var Primary500: UIColor { return UIColor(hexaRGB: "578fe3") ?? UIColor.white }
    static var Primary600: UIColor { return UIColor(hexaRGB: "3579dd") ?? UIColor.white }
    static var Primary700: UIColor { return UIColor(hexaRGB: "1d56ab") ?? UIColor.white }
    static var Primary800: UIColor { return UIColor(hexaRGB: "18478d") ?? UIColor.white }
    static var Primary900: UIColor { return UIColor(hexaRGB: "13386f") ?? UIColor.white }
    static var Primary1000: UIColor { return UIColor(hexaRGB: "0e2952") ?? UIColor.white }
    
    // Secondary
    static var Secondary100: UIColor { return UIColor(hexaRGB: "E7EBEF") ?? UIColor.white }
    static var Secondary200: UIColor { return UIColor(hexaRGB: "DAE1E7") ?? UIColor.white }
    static var Secondary300: UIColor { return UIColor(hexaRGB: "CED7DE") ?? UIColor.white }
    static var Secondary400: UIColor { return UIColor(hexaRGB: "C2CDD6") ?? UIColor.white }
    static var Secondary500: UIColor { return UIColor(hexaRGB: "B6C3CD") ?? UIColor.white }
    static var Secondary600: UIColor { return UIColor(hexaRGB: "92A5B5") ?? UIColor.white }
    static var Secondary700: UIColor { return UIColor(hexaRGB: "7991A4") ?? UIColor.white }
    static var Secondary800: UIColor { return UIColor(hexaRGB: "637D92") ?? UIColor.white }
    static var Secondary900: UIColor { return UIColor(hexaRGB: "4A5E6D") ?? UIColor.white }
    static var Secondary1000: UIColor { return UIColor(hexaRGB: "323F49") ?? UIColor.white }
    
    // Neutrals
    static var Neutrals100: UIColor { return UIColor(hexaRGB: "E8EBED") ?? UIColor.white }
    static var Neutrals200: UIColor { return UIColor(hexaRGB: "D2D6DB") ?? UIColor.white }
    static var Neutrals300: UIColor { return UIColor(hexaRGB: "BBC2C9") ?? UIColor.white }
    static var Neutrals400: UIColor { return UIColor(hexaRGB: "A4ADB6") ?? UIColor.white }
    static var Neutrals500: UIColor { return UIColor(hexaRGB: "828F9B") ?? UIColor.white }
    static var Neutrals600: UIColor { return UIColor(hexaRGB: "64707D") ?? UIColor.white }
    static var Neutrals700: UIColor { return UIColor(hexaRGB: "40474F") ?? UIColor.white }
    static var Neutrals800: UIColor { return UIColor(hexaRGB: "2D3339") ?? UIColor.white }
    static var Neutrals900: UIColor { return UIColor(hexaRGB: "2B2829") ?? UIColor.white }
    static var Neutrals1000: UIColor { return UIColor(hexaRGB: "121417") ?? UIColor.white }
    
    // Success
    static var Success100: UIColor { return UIColor(hexaRGB: "E2F2C4") ?? UIColor.white }
    static var Success200: UIColor { return UIColor(hexaRGB: "C4E688") ?? UIColor.white }
    static var Success300: UIColor { return UIColor(hexaRGB: "79A924") ?? UIColor.white }
    
    // Warning
    static var Warning100: UIColor { return UIColor(hexaRGB: "fff2aa") ?? UIColor.white }
    static var Warning200: UIColor { return UIColor(hexaRGB: "ffe455") ?? UIColor.white }
    static var Warning300: UIColor { return UIColor(hexaRGB: "b39600") ?? UIColor.white }
    
    // Error
    static var Error100: UIColor { return UIColor(hexaRGB: "ffbeba") ?? UIColor.white }
    static var Error200: UIColor { return UIColor(hexaRGB: "ff7c75") ?? UIColor.white }
    static var Error300: UIColor { return UIColor(hexaRGB: "d30b00") ?? UIColor.white }
}

