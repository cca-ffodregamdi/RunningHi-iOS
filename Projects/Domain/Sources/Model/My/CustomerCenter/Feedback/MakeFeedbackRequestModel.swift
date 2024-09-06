//
//  MakeFeedbackRequestModel.swift
//  Domain
//
//  Created by 유현진 on 8/28/24.
//

import Foundation

public struct MakeFeedbackRequestModel: Codable{
    let title: String
    let content: String
    let category: FeedbackCategory
    
    public init(title: String, content: String, category: FeedbackCategory) {
        self.title = title
        self.content = content
        self.category = category
    }
}
