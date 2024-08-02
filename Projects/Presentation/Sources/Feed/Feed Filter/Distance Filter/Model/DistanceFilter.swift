//
//  DistanceFilter.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import Foundation

public enum DistanceFilter{
    case around
    case around5
    case around10
    case all
    
    var title: String{
        switch self{
        case .around: "우리동네"
        case .around5: "+5km"
        case .around10: "+10km"
        case .all: "전국"
        }
    }
    
    var silderOffset: Float{
        switch self{
        case .around: 0.0
        case .around5: 1.0
        case .around10: 2.0
        case .all: 3.0
        }
    }
}
