//
//  SignWithApple.swift
//  Domain
//
//  Created by 유현진 on 7/3/24.
//

import Foundation

public struct SignWithApple: Codable{
    let authorizationCode: String
    let identityToken: String
    
    enum CodingKeys: CodingKey {
        case authorizationCode
        case identityToken
    }
    
    public init(authorizationCode: String, identityToken: String) {
        self.authorizationCode = authorizationCode
        self.identityToken = identityToken
    }
}
