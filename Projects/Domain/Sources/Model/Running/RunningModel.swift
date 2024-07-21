//
//  RunningModel.swift
//  Domain
//
//  Created by najin on 7/20/24.
//

import Foundation

public struct RunningModel {
    public var startTime = Date()
    public var endTime = Date()
    
    public var runningTime = 0
    public var distance = 0.0
    public var averagePace = 0
    public var calorie = 0
    
    public var routeList: [RouteInfo] = []
    
    public init() { }
}
