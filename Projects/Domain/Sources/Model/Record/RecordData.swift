//
//  RecordData.swift
//  Domain
//
//  Created by najin on 7/28/24.
//

import Foundation

public struct RecordData {
    public var chartType: RecordChartType = .weekly
    public var date: Date = Date()
    public var chartDatas: [RunningRecordChartData]
    public let totalTime: Int
    public let meanPace: Int
    public let totalKcal: Int
    public let runningRecords: [RunningRecordData]
    
    public init(chartType: RecordChartType,
                date: Date,
                chartDatas: [RunningRecordChartData]?,
                totalTime: Int,
                meanPace: Int,
                totalKcal: Int,
                runningRecords: [RunningRecordData]) {
        self.chartType = chartType
        self.date = date
        self.chartDatas = chartDatas ?? []
        self.totalTime = totalTime
        self.meanPace = meanPace
        self.totalKcal = totalKcal
        self.runningRecords = runningRecords
    }
}

public struct RunningRecordData: Decodable {
    public let postNo: Int
    public let createDate: String
    public let locationName: String
    public let distance: Double
    public let time: Int
    public let imageUrl: String
    public let status: Bool
    public let difficulty: String
    public let title: String
    
    public init(postNo: Int,
                createDate: String,
                locationName: String,
                distance: Double,
                time: Int,
                imageUrl: String,
                status: Bool,
                difficulty: String,
                title: String) {
        self.postNo = postNo
        self.createDate = createDate
        self.locationName = locationName
        self.distance = distance
        self.time = time
        self.imageUrl = imageUrl
        self.status = status
        self.difficulty = difficulty
        self.title = title
    }
}

public struct RunningRecordChartData: Decodable {
    public let distance: Double
    public let time: Int
    public let pace: Int
    public let kcal: Int
    
    public init(distance: Double,
                time: Int,
                pace: Int,
                kcal: Int) {
        self.distance = distance
        self.time = time
        self.pace = pace
        self.kcal = kcal
    }
}
