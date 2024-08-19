//
//  MyUserInfoDTO.swift
//  Data
//
//  Created by 유현진 on 8/19/24.
//

import Foundation
import Domain

public struct MyUserInfoDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: MyUserInfoModel
}


