//
//  RankModel.swift
//  Domain
//
//  Created by 유현진 on 6/2/24.
//

import Foundation

public struct RankModel{
    public let rank: Int
    public let nickName: String
    public let distance: Int
    
    public init(rank: Int, nickName: String, distance: Int) {
        self.rank = rank
        self.nickName = nickName
        self.distance = distance
    }
}
