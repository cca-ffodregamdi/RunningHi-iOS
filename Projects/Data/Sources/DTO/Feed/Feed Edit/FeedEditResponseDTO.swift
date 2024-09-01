//
//  FeedEditResponseDTO.swift
//  Data
//
//  Created by najin on 9/1/24.
//

import Foundation
import Domain

public struct FeedEditResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
}
