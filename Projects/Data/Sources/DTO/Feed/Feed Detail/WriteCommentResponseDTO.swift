//
//  WriteCommentResponseDTO.swift
//  Data
//
//  Created by 유현진 on 8/31/24.
//

import Foundation
import Domain

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
    public let likeCnt: Int?

    func toEntity() -> WriteCommentModel{
        return WriteCommentModel(likeCount: likeCnt ?? 0)
    }
}
