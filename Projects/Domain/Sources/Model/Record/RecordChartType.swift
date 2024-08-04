//
//  RecordChartType.swift
//  Domain
//
//  Created by najin on 7/28/24.
//

import Foundation

public enum RecordChartType: String {
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
    
    public var calendarType: Calendar.Component {
        switch self {
        case .weekly:
            return .weekOfYear
        case .monthly:
            return .month
        case .yearly:
            return .year
        }
    }
}
