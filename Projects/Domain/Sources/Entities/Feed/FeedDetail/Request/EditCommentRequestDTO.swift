//
//  EditCommentRequestDTO.swift
//  Domain
//
//  Created by 유현진 on 7/13/24.
//

import Foundation

public struct EditCommentRequestDTO: Codable{
    let replyContent: String
    
    public init(commentContent: String) {
        self.replyContent = commentContent
    }
}
