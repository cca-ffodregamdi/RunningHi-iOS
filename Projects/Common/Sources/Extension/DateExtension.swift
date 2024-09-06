//
//  DateExtension.swift
//  Common
//
//  Created by 유현진 on 5/28/24.
//

import Foundation

public extension Date{
    func formatSecondsToHHMMSS(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        
        let formattedString = formatter.string(from: TimeInterval(seconds)) ?? "00:00:00"
        return formattedString
    }
    
    func formatChallengeTermToMd(dateString: String) -> String{
        let possibleFormats = [
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        for format in possibleFormats{
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString){
                let MdFormatter = DateFormatter()
                MdFormatter.dateFormat = "M월 d일"
                return MdFormatter.string(from: date)
            }
        }
        return "알 수 없음"
    }
    
    static func convertDateToChallengeDetail(date: Date) -> String {
        // 변환할 출력 형식을 설정하는 DateFormatter
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        formatter.dateFormat = "M월 d일" // "8월 31일" 형식
        
        // Date를 문자열로 변환하여 반환
        return formatter.string(from: date)
    }
    
    func convertDateToFormat(format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
    
    func formatNoticeCreateDate(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        if let data = dateFormatter.date(from: dateString){
            let resultDate = DateFormatter()
            resultDate.dateFormat = "YYYY.MM.dd"
            return resultDate.string(from: data)
        }
        
        return "알 수 없음"
    }
    
    func formatFeedbackCreateDate(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        if let data = dateFormatter.date(from: dateString){
            let resultDate = DateFormatter()
            resultDate.dateFormat = "YYYY.MM.dd HH:mm:ss"
            return resultDate.string(from: data)
        }
        
        return "알 수 없음"
    }
    
    func isTwoWeeksPassedForNotice(dateString: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        guard let date = dateFormatter.date(from: dateString) else { return false }
        
        let currentDate = Date()
        let twoWeeks: TimeInterval = 60 * 60 * 24 * 7 * 2
        
        return currentDate.timeIntervalSince(date) > twoWeeks
    }
    
    static func formatDateForFeedback(date: Date) -> String{
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dataFormatter.string(from: date)
    }
    
    static func formatForFeedDetail(date: Date) -> String{
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)
        
        if let minute = components.minute, let hour = components.hour, let day = components.day, let month = components.month, let year = components.year {
            if year > 0 {
                return "\(year)년 전"
            } else if month > 0 {
                return "\(month)달 전"
            } else if day > 0 {
                return "\(day)일 전"
            } else if hour > 0 {
                return "\(hour)시간 전"
            } else if minute > 0 {
                return "\(minute)분 전"
            } else {
                return "방금 전"
            }
        } else {
            return "오래 전"
        }
    }
}
