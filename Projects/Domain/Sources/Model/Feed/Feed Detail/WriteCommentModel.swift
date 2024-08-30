//
//  WriteCommentResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 6/13/24.
//

import Foundation

public struct WriteCommentModel{
    public let likeCount: Int
    
    public init(likeCount: Int) {
        self.likeCount = likeCount
    }
}
