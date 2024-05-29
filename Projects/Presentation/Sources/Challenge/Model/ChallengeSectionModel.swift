//
//  ChallengeSectionModel.swift
//  Presentation
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import RxDataSources
import Domain

enum ChallengeSection{
    case participating([ChallengeModel])
    case notParticipaing([ChallengeModel])
}

extension ChallengeSection: SectionModelType{
    var header: String{
        switch self{
        case .notParticipaing:
            return "오픈된 챌린지"
        case .participating:
            return "참여 중인 챌린지"
        }
    }
    typealias Item = ChallengeModel
    
    var items: [ChallengeModel]{
        switch self{
        case .participating(let models):
            return models
        case .notParticipaing(let models):
            return models
        }
    }
    
    init(original: ChallengeSection, items: [ChallengeModel]) {
        switch original{
        case .participating:
            self = .participating(items)
        case .notParticipaing:
            self = .notParticipaing(items)
        }
    }
}
