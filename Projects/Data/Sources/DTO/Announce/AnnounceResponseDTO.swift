//
//  AnnounceResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import Domain

public struct AnnounceResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [AnnounceModel]
}


