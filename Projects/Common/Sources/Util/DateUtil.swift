//
//  DateUtil.swift
//  Common
//
//  Created by najin on 8/3/24.
//

import Foundation

public struct DateUtil {
    
    public static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }
    
    // 서버 형식의 dateString을 format에 맞는 String으로 변환한다.
    public static func formatDateStringToString(dateString: String, format: String = "MM월 dd일") -> String{
        let possibleFormats = [
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        ]
        
        for format in possibleFormats{
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString){
                let MdFormatter = DateFormatter()
                MdFormatter.dateFormat = format
                return MdFormatter.string(from: date)
            }
        }
        return "알 수 없음"
    }
    
    // date에서 DateType에 따라 format을 출력한다.
    public static func dateToChartRangeFormatByType(type: Calendar.Component, date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        if type == .year {
            guard let year = components.year else { return "-" }
            return "\(year)년"
        } else if type == .month {
            guard let month = components.month else { return "-" }
            return "\(month)월"
        } else if type == .weekOfYear {
            if getBetweenDateType(type: type, date: date) == 0 {
                return "이번주"
            } else if getBetweenDateType(type: type, date: date) == 1 {
                return "저번주"
            } else {
                let (startDate, endDate) = startAndEndOfWeek(date: date)
                guard let monday = startDate, let sunday = endDate else { return "-" }
                return "\(monday.convertDateToFormat(format: "MM.dd")) ~ \(sunday.convertDateToFormat(format: "MM.dd"))"
            }
        }
        
        return "-"
    }
    
    // date에서 N(increase)만큼 기간(year / month / week)이 경과했을 때의 날짜를 출력한다.
    public static func getRangedDate(increase: Int, type: Calendar.Component, date: Date) -> Date {
        let calendar = Calendar.current
        
        if let nextDate = calendar.date(byAdding: type, value: increase, to: date) {
            return nextDate
        } else {
            return Date()
        }
    }
    
    // date가 주어졌을 때 DateType에 따라 오늘로부터 얼마의 기간이 지났는지 출력한다.
    public static func getBetweenDateType(type: Calendar.Component, date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([type], from: date, to: Date())
        
        return (type == .weekOfYear ? components.weekOfYear : (type == .month ? components.month : components.year)) ?? 0
    }
    
    // date가 주어졌을 때 DateType에 따라 아직 오지 않은 기간인지 출력한다.
    public static func isDateInFuture(type: Calendar.Component, date: Date) -> Bool {
        let calendar = Calendar.current

        let currentDate = calendar.component(type, from: Date())
        let specificDate = calendar.component(type, from: date)
        
        if type == .year {
            return currentDate < specificDate
        } else {
            let currentYear = calendar.component(.year, from: Date())
            let specificYear = calendar.component(.year, from: date)
            
            if currentYear < specificYear {
                return true
            } else if currentYear > specificYear {
                return false
            } else {
                return currentDate < specificDate
            }
        }
    }
    
    // date가 주어졌을 때 그 날짜가 속한 주의 월요일 날짜와 일요일 날짜를 출력한다.
    public static func startAndEndOfWeek(date: Date) -> (startOfWeek: Date?, endOfWeek: Date?) {
        let calendar = Calendar.current
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
            return (nil, nil)
        }
        
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)
        return (startOfWeek, endOfWeek)
    }
}
