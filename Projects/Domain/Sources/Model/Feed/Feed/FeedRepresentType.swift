//
//  FeedRepresentType.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import Foundation

public enum FeedRepresentType: String, Decodable, CaseIterable {
    case distance = "거리"
    case time = "시간"
    case pace = "페이스"
    case kcal = "칼로리"
    case none = "선택 안 함"
    
    public var typeNo: Int {
        switch self {
        case .distance:
            return 0
        case .time:
            return 1
        case .pace:
            return 3
        case .kcal:
            return 2
        case .none:
            return 0
        }
    }
}
