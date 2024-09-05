//
//  RunningResultRequestDTO.swift
//  Data
//
//  Created by najin on 7/21/24.
//

import Foundation
import Domain

public struct RunningResultDTO: Codable {
    
    public let runInfo: RunningResultRunInfoDTO?
    public let sectionData: RunningResultSectionDTO?
    public let gpsData: [RunningResultGPSDTO]?
    
    public static func fromEntity(data: RunningResult) -> RunningResultDTO {
        return RunningResultDTO(runInfo: RunningResultRunInfoDTO(runStartDate: "\(data.startTime.convertDateToFormat(format: "yyyy-MM-dd'T'HH:mm:ss"))",
                                                                        location: data.location,
                                                                        distance: data.distance,
                                                                        time: data.runningTime,
                                                                        kcal: data.calorie,
                                                                        meanPace: data.averagePace,
                                                                        difficulty: data.difficulty.rawValue),
                                       sectionData: RunningResultSectionDTO(pace: data.sectionPace,
                                                                            kcal: data.sectionKcal),
                                       gpsData: data.routeList.map {
                                                return RunningResultGPSDTO(lon: $0.longitude,
                                                                           lat: $0.latitude,
                                                                           time: "\($0.timestamp.convertDateToFormat(format: "yyyy-MM-dd'T'HH:mm:ss"))")
        })
    }
}

public struct RunningResultRunInfoDTO: Codable {
    let runStartDate: String
    let location: String
    let distance: Double
    let time: Int
    let kcal: Int
    let meanPace: Int
    let difficulty: String
}

public struct RunningResultSectionDTO: Codable {
    let pace: [Int]
    let kcal: [Int]
}

public struct RunningResultGPSDTO: Codable {
    let lon: Double
    let lat: Double
    let time: String
}
