//
//  ChallengeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 5/29/24.
//

import Foundation

public struct ChallengeModel{
    public let title: String
    public let distance: Int
    public let memberCount: Int
    public let isParticipating: Bool
    
    public init(title: String, distance: Int, memberCount: Int, isParticipating: Bool) {
        self.title = title
        self.distance = distance
        self.memberCount = memberCount
        self.isParticipating = isParticipating
    }
}
