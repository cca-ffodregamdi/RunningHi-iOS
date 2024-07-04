//
//  RankSection.swift
//  Presentation
//
//  Created by 유현진 on 6/2/24.
//

import Foundation
import Domain
import RxDataSources

public enum RankSection{
    case topRank([RankModel])
    case otherRank([RankModel])
}

extension RankSection: SectionModelType{
    
    var header: String{
        return "랭킹"
    }
    
    public typealias Item = RankModel
    
    public var items: [RankModel]{
        switch self{
        case .topRank(let models):
            return models
        case .otherRank(let models):
            return models
        }
    }
    
    public init(original: RankSection, items: [RankModel]) {
        switch original{
        case .topRank(let models):
            self = .topRank(models)
        case .otherRank(let models):
            self = .otherRank(models)
        }
    }
    
}
