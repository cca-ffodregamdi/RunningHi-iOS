//
//  LoginKakaoRequest.swift
//  Domain
//
//  Created by 유현진 on 6/10/24.
//

import Foundation

public struct LoginKakaoRequest: Codable{
    var kakaoToken: String
    
    enum CodingKeys: CodingKey {
        case kakaoToken
    }
    
    public init(kakaoToken: String) {
        self.kakaoToken = kakaoToken
    }
}
