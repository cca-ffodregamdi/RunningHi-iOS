//
//  RunningResultResponseDTO.swift
//  Data
//
//  Created by najin on 8/25/24.
//

import Foundation

public struct RunningResultResponseDTO: Decodable {
    let timeStamp: String
    let status: String
    let message: String
    
    public let data: PostNoDTO
}

public struct PostNoDTO: Decodable {
    let postNo: Int
}
