//
//  IntExtension.swift
//  Common
//
//  Created by 유현진 on 7/9/24.
//

import Foundation

public extension Int{
    static func convertMeanPaceToString(meanPace: Int) -> String{
        var meanPaceMin: String {
            return meanPace / 60 != 0 ? "\(meanPace / 60)’" : ""
        }
        var meanPaceSec: String {
            if meanPace % 60 == 0 {
                return "00”"
            }else if meanPace % 60 < 10{
                return "0\(meanPace % 60)”"
            }else{
                return "\(meanPace % 60)”"
            }
        }
        return meanPaceMin+meanPaceSec
    }
    
    static func convertTimeToCalorie(time: Int) -> Int {
        return Int(((3.5 / 60) * 7 * 60 * Double(time) / 1000) * 5)
    }
    
    static func convertTimeAndDistanceToPace(time: Int, distance: Double) -> Int {
        return Int(Double(time) / distance)
    }
}
