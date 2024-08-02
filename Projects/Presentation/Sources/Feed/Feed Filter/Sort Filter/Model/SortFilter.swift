//
//  SortFilter.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import Foundation

public enum SortFilter{
    case latest
    case recommended
    case like
    case distance
    
    var title: String {
        switch self{
        case .latest:  "최근순"
        case .recommended: "추천순"
        case .like: "좋아요순"
        case .distance: "거리순"
        }
    }
}
