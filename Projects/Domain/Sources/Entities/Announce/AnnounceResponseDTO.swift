//
//  AnnounceResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 8/5/24.
//

import Foundation

public struct AnnounceResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [AnnounceModel]
}

public struct AnnounceModel: Decodable{
    public let title: String
    public let content: String
    public let isRead: Bool
    public let createDate: String
}
