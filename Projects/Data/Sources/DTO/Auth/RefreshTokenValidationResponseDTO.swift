//
//  RefreshTokenValidationResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/10/24.
//

import Foundation

public struct RefreshTokenValidationResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: Bool?
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}
