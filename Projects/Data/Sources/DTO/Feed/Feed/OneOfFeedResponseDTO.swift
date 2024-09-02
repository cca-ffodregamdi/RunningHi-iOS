//
//  OneOfFeedResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/2/24.
//

import Foundation

public struct OneOfFeedResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedResponseModel
    
    public enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}


