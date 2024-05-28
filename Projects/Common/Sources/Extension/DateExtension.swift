//
//  DateExtension.swift
//  Common
//
//  Created by 유현진 on 5/28/24.
//

import Foundation

public extension Date{
    func createDateToString(createDate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        if let date = dateFormatter.date(from: createDate){
            let intervalTime = Int(floor(Date().timeIntervalSince(date) / 60))
            if intervalTime < 1 {
                return "방금 전"
            }else if intervalTime < 60 {
                return "\(intervalTime)분 전"
            }else if intervalTime < 60 * 24{
                return "\(intervalTime/60)시간 전"
            }else if intervalTime < 60 * 24 * 365{
                return "\(intervalTime/60/24)일 전"
            }else{
                return "\(intervalTime/60/24/365)년 전"
            }
        }else{
            return "알 수 없음"
        }
        
    }
}
