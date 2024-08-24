//
//  RecordDeleteResponseDTO.swift
//  Data
//
//  Created by najin on 8/19/24.
//

import Foundation

public struct RecordDeleteResponseDTO: Decodable {
    let timeStamp: String
    let status: String
    let message: String
    
    public let data: RecordPostDTO
}

public struct RecordPostDTO: Decodable {
    let postNo: Int
}
