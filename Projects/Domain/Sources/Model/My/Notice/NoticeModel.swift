//
//  NoticeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/18/24.
//

import Foundation

public struct NoticeModel{
    public let noticeId: Int
    public let title: String
    public let content: String
    public let createDate: Date
    
    public init(noticeId: Int, title: String, content: String, createDate: Date) {
        self.noticeId = noticeId
        self.title = title
        self.content = content
        self.createDate = createDate
    }
}
