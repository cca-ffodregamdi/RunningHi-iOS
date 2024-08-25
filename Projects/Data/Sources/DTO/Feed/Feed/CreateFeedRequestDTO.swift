//
//  CreateFeedRequestDTO.swift
//  Data
//
//  Created by najin on 8/25/24.
//

import Foundation

public struct CreateFeedRequestDTO: Codable{
    let postNo: Int
    let postContent: String
    let difficulty: String
    let mainData: Int
    let imageUrl: String
}
