//
//  TimeUtil.swift
//  Common
//
//  Created by najin shin on 7/11/24.
//

import Foundation

public struct TimeUtil {
    public static func convertSecToTimeFormat(sec: Int, format: String = "HH:mm:ss") -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        if let formattedString = formatter.string(from: TimeInterval(sec)) {
            return formattedString
        } else {
            return "00:00:00"
        }
    }
}
