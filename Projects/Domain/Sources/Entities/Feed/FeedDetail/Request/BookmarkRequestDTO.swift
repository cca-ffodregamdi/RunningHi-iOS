//
//  BookmarkRequestDTO.swift
//  Domain
//
//  Created by 유현진 on 6/14/24.
//

import Foundation

public struct BookmarkRequestDTO: Codable{
    let postNo: Int
    
    public init(postNo: Int) {
        self.postNo = postNo
    }
    
    enum CodingKeys: CodingKey {
        case postNo
    }
}
