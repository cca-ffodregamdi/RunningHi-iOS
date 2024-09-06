//
//  AnnounceModel.swift
//  Domain
//
//  Created by 유현진 on 8/20/24.
//

import Foundation

public struct AnnounceModel: Decodable{
    public let title: String
    public let announceId: Int
    public let isRead: Bool
    public let createDate: Date
    
    public init(title: String, announceId: Int, isRead: Bool, createDate: Date) {
        self.title = title
        self.announceId = announceId
        self.isRead = isRead
        self.createDate = createDate
    }
}
