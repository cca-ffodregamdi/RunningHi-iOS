//
//  ReportCommentRequestDTO.swift
//  Domain
//
//  Created by 유현진 on 6/23/24.
//

import Foundation

public struct ReportCommentRequestDTO: Codable{
    let category: String
    var content: String?
    let reportedReplyNo: Int
    
    public init(category: String, content: String? = nil, commentId: Int) {
        self.category = category
        self.content = content
        self.reportedReplyNo = commentId
    }
}
