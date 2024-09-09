//
//  UserLocation.swift
//  Domain
//
//  Created by 유현진 on 8/14/24.
//

import Foundation

public struct UserLocation: Codable{
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
