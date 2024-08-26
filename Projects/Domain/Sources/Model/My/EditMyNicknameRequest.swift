//
//  EditMyNicknameRequest.swift
//  Domain
//
//  Created by 유현진 on 8/26/24.
//

import Foundation

public struct EditMyNicknameRequest: Codable{
    let nickname: String
    
    public init(nickname: String) {
        self.nickname = nickname
    }
}
