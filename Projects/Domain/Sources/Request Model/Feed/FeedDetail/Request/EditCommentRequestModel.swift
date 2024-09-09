//
//  EditCommentRequestModel.swift
//  Domain
//
//  Created by 유현진 on 7/13/24.
//

import Foundation

public struct EditCommentRequestModel: Codable{
    let replyContent: String
    
    public init(commentContent: String) {
        self.replyContent = commentContent
    }
}
