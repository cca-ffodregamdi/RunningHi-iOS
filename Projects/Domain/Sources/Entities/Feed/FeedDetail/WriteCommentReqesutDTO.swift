//
//  WriteCommentReqesutDTO.swift
//  Domain
//
//  Created by 유현진 on 6/13/24.
//

import Foundation

public struct WriteCommentReqesutDTO: Codable{
    public let postNo: Int
    let replyContent: String
    
    enum CodingKeys: String, CodingKey {
        case postNo
        case replyContent
    }
    
    public init(postId: Int, content: String) {
        self.postNo = postId
        self.replyContent = content
    }
}
