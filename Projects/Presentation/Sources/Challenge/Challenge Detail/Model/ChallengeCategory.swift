//
//  ChallengeCategory.swift
//  Presentation
//
//  Created by 유현진 on 7/9/24.
//

import Foundation
import Domain
import Common

struct ChallengeCategory{
    let category: ChallengeCategoryType
    let record: Float
    let goal: Float
    
    init(category: ChallengeCategoryType, record: Float, goal: Float) {
        self.category = category
        self.record = record
        self.goal = goal
    }
    
    var recordString: String{
        switch category{
        case .SPEED:
            return "\(Int.convertMeanPaceToString(meanPace: Int(record)))/"
        case .ATTENDANCE:
            return "\(Int(record))회/"
        case .DISTANCE:
            return "\(record)/"
        }
    }
    
    var goalString: String{
        switch category{
        case .SPEED:
            return "평균 \(Int.convertMeanPaceToString(meanPace: Int(goal)))"
        case .ATTENDANCE:
            return "\(Int(goal))회"
        case .DISTANCE:
            return "\(goal)km"
        }
    }
}
