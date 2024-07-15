//
//  SignWithApple.swift
//  Domain
//
//  Created by 유현진 on 7/3/24.
//

import Foundation

public struct SignWithApple: Codable{
    let authorizationCode: String
    let identityCode: String
    
    enum CodingKeys: CodingKey {
        case authorizationCode
        case identityCode
    }
    
    public init(authorizationCode: String, identityCode: String) {
        self.authorizationCode = authorizationCode
        self.identityCode = identityCode
    }
}
