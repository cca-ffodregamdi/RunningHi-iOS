//
//  RunningResultRequestDTO.swift
//  Data
//
//  Created by najin on 7/21/24.
//

import Foundation
import Domain

public struct RunningResultRequestDTO: Codable {
    
    var file: String?
    var data: RunningResultData?
    
    public init() { }
    
    public init(file: String, runStartDate: String, location: String, distance: Double, time: Int, kcal: Int, meanPace: Int, difficulty: String, sectionPace: [Int], sectionKcal: [Int]) {
        self.file = file
        self.data = RunningResultData(runStartDate: runStartDate,
                                      location: location,
                                      distance: distance,
                                      time: time,
                                      kcal: kcal,
                                      meanPace: meanPace,
                                      difficulty: difficulty,
                                      sectionPace: sectionPace,
                                      sectionKcal: sectionKcal)
    }
    
    static func fromEntity(_ from: RunningResult) -> RunningResultRequestDTO {
        return RunningResultRequestDTO(file: "",
                                       runStartDate: "",
                                       location: "",
                                       distance: 0.0,
                                       time: 0,
                                       kcal: 0,
                                       meanPace: 0,
                                       difficulty: "",
                                       sectionPace: [],
                                       sectionKcal: []
        )
    }
}

public struct RunningResultData: Codable {
    var runStartDate: String?
    var location: String?
    var distance: Double?
    var time: Int?
    var kcal: Int?
    var meanPace: Int?
    var difficulty: String?
    var sectionPace: [Int]?
    var sectionKcal: [Int]?
    
    init() { }
    
    init(runStartDate: String, location: String, distance: Double, time: Int, kcal: Int, meanPace: Int, difficulty: String, sectionPace: [Int], sectionKcal: [Int]) {
        self.runStartDate = runStartDate
        self.location = location
        self.distance = distance
        self.time = time
        self.kcal = kcal
        self.meanPace = meanPace
        self.difficulty = difficulty
        self.sectionPace = sectionPace
        self.sectionKcal = sectionKcal
    }
}
