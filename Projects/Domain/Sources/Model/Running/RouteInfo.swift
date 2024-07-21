//
//  RouteInfo.swift
//  Domain
//
//  Created by najin shin on 7/12/24.
//

import Foundation
import CoreLocation

public struct RouteInfo: Codable, Equatable {
    public var timestamp: Date
    
    public var latitude: Double
    public var longitude: Double
    
    public var runningTime: Int = 0
    public var distance: Double = 0.0
    
    public init(latitude: Double, longitude: Double, timestamp: Date = Date()) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
    
    public init(coordinate: CLLocationCoordinate2D, timestamp: Date = Date()) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = timestamp
    }
}
