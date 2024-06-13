//
//  WriteCommentResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 6/13/24.
//

import Foundation

public struct WriteCommentResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: WriteCommentResponseModel
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct WriteCommentResponseModel: Decodable{
    public let replyNo: Int
    let memberName: String
    let postNo: Int
    let replyContent: String
    let isDeleted: Bool
    let createDate: String
    let updateDate: String
    
    enum CodingKeys: CodingKey {
        case replyNo
        case memberName
        case postNo
        case replyContent
        case isDeleted
        case createDate
        case updateDate
    }
}
