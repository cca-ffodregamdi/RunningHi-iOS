//
//  RunningResult.swift
//  Domain
//
//  Created by najin on 7/20/24.
//

import Foundation

public struct RunningResult {
    public var startTime = Date()
    
    public var location = ""
    public var difficulty: FeedDetailDifficultyType = .NORMAL
    
    public var runningTime = 0
    public var distance = 0.0
    public var averagePace = 0
    public var calorie = 0
    
    public var routeList: [RouteInfo] = []
    public var sectionPace: [Int] = []
    public var sectionKcal: [Int] = []
    
    public init() { }
    
    public init(startTime: Date,
                time: Int,
                location: String,
                difficulty: FeedDetailDifficultyType, 
                runningTime: Int,
                distance: Double,
                averagePace: Int,
                calorie: Int) {
        self.startTime = startTime
        self.runningTime = time
        self.location = location
        self.difficulty = difficulty
        self.runningTime = runningTime
        self.distance = distance
        self.averagePace = averagePace
        self.calorie = calorie
    }
}
