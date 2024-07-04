//
//  ChallengeSectionModel.swift
//  Presentation
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import RxDataSources
import Domain

struct ChallengeSectionModel {
    var header: String
    var items: [Item]
}

extension ChallengeSectionModel: SectionModelType {
    typealias Item = ChallengeItem
    
    init(original: ChallengeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

enum ChallengeItem{
    case participating(MyChallengeModel)
    case notParticipaing(ChallengeModel)
}
