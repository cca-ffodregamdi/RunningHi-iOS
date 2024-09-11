//
//  RecordResponseDTO.swift
//  Domain
//
//  Created by najin on 7/28/24.
//

import Foundation
import Domain

public struct RecordResponseDTO: Decodable {
    let timeStamp: String
    let status: String
    let message: String
    
    public let data: WeeklyRecordDataDTO
}

public struct WeeklyRecordDataDTO: Decodable {
    public let weeklyRecordData: [RecordChartDataListDTO]?
    public let monthlyRecordData: [RecordChartDataListDTO]?
    public let yearlyRecordData: [RecordChartDataListDTO]?
    public let runCnt: Int?
    public let totalTime: Int?
    public let meanPace: Int?
    public let totalKcal: Int?
    public let recordPostList: [RecordPostListDTO]
    
    public func toEntity(chartType: RecordChartType, date: Date) -> RecordData {
        var chartData: [RecordChartDataListDTO] = []
        switch chartType {
        case .weekly:
            chartData = weeklyRecordData ?? []
        case .monthly:
            chartData = monthlyRecordData ?? []
        case .yearly:
            chartData = yearlyRecordData ?? []
        }
        
        return RecordData(chartType: chartType,
                          date: date,
                          chartDatas: chartData.map{$0.toEntity},
                          runCnt: runCnt ?? 0,
                          totalTime: totalTime ?? 0,
                          meanPace: meanPace ?? 0,
                          totalKcal: totalKcal ?? 0,
                          runningRecords: recordPostList.map{$0.toEntity})
    }
}

public struct RecordPostListDTO: Decodable {
    public let postNo: Int
    public let createDate: String?
    public let locationName: String?
    public let distance: Double?
    public let time: Int?
    public let imageUrl: String?
    public let status: Bool?
    public let difficulty: String?
    public let title: String?
    
    public var toEntity: RunningRecordData {
        return RunningRecordData(postNo: postNo,
                                 createDate: createDate ?? "",
                                 locationName: locationName ?? "",
                                 distance: distance ?? 0.0,
                                 time: time ?? 0,
                                 imageUrl: imageUrl ?? "",
                                 status: status ?? false,
                                 difficulty: difficulty ?? "EASY",
                                 title: title ?? "")
    }
}

public struct RecordChartDataListDTO: Decodable {
    public let distance: Double?
    public let time: Int?
    public let meanPace: Int?
    public let kcal: Int?
    
    public var toEntity: RunningRecordChartData {
        return RunningRecordChartData(distance: distance ?? 0.0,
                                      time: time ?? 0,
                                      pace: meanPace ?? 0,
                                      kcal: kcal ?? 0)
    }
}
