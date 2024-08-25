//
//  Date+Extension.swift
//  Data
//
//  Created by najin on 8/26/24.
//

import Foundation

extension Date {
    public static func formatDateStringToDate(dateString: String) -> Date? {
        let possibleFormats = [
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        ]
        
        for format in possibleFormats{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.locale = Locale(identifier: "ko_KR")
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    func convertDateToFormat(format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
}
