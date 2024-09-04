//
//  CommentsResponseDTO.swift
//  Data
//
//  Created by 유현진 on 8/30/24.
//

import Foundation
import Domain

public struct CommentsResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: CommentsResponseData
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct CommentsResponseData: Decodable{
    public let content: [CommentsResponseModel]
    
    enum CodingKeys: CodingKey {
        case content
    }
}


public struct CommentsResponseModel: Decodable{
    public let replyNo: Int
    public let memberName: String?
    public let memberNo: Int
    public let postNo: Int
    public let replyContent: String?
    public let reportedCount: Int?
    public let isDeleted: Bool?
    public let profileImageUrl: String?
    public let createDate: String?
    public let isUpdated: Bool?
    public let isOwner: Bool?
    
    func toEntity() -> CommentModel{
        return CommentModel(commentId: replyNo,
                            nickname: memberName ?? "",
                            userId: memberNo,
                            postId: postNo,
                            content: replyContent ?? "",
                            reportedCount: reportedCount ?? 0,
                            isDeleted: isDeleted ?? false,
                            profileUrl: profileImageUrl,
                            createDate: Date.formatDateStringToDate(dateString: createDate ?? "") ?? Date(),
                            isUpdated: isUpdated ?? false,
                            isOwner: isOwner ?? false)
    }

}
