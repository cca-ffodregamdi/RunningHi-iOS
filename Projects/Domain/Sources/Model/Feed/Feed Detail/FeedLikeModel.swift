//
//  FeedLikeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/10/24.
//

import Foundation

public struct FeedLikeModel: Decodable{
    public let likeCount: Int
    
    public init(likeCount: Int) {
        self.likeCount = likeCount
    }
}
