//
//  FeedLikeRequestDTO.swift
//  Domain
//
//  Created by 유현진 on 7/2/24.
//

import Foundation

public struct FeedLikeRequestDTO: Codable{
    let postNo: Int
    
    public init(postNo: Int) {
        self.postNo = postNo
    }
}
