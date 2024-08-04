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
    public let weeklyRecordData: [Double]?
    public let monthlyRecordData: [Double]?
    public let yearlyRecordData: [Double]?
    public let totalTime: Int?
    public let meanPace: Int?
    public let totalKcal: Int?
    public let recordPostList: [RecordPostListDTO]
    
    public func toEntity(chartType: RecordChartType, date: Date) -> RecordData {
        return RecordData(chartType: chartType,
                          date: date,
                          chartDatas: chartType == .monthly ? monthlyRecordData : (chartType == .yearly ? yearlyRecordData : weeklyRecordData),
                          totalTime: totalTime ?? 0,
                          meanPace: meanPace ?? 0,
                          totalKcal: totalKcal ?? 0,
                          runningRecords: recordPostList.map{$0.toEntity})
                          // TestCase
//                          runningRecords: [
//                                            RunningRecordData(postNo: 30,
//                                                             createDate: "2024-02-04T14:23:39",
//                                                             locationName: "대전",
//                                                             distance: 6.8,
//                                                             time: 6120,
//                                                             imageUrl: "",
//                                                             status: true,
//                                                             difficulty: "EASY_NORMAL",
//                                                             title: ""),
//                                           RunningRecordData(postNo: 30,
//                                                              createDate: "2024-02-04T14:23:39",
//                                                              locationName: "대전",
//                                                              distance: 6.8,
//                                                              time: 6120,
//                                                              imageUrl: "",
//                                                              status: true,
//                                                              difficulty: "EASY_NORMAL",
//                                                              title: ""),
//                                           RunningRecordData(postNo: 30,
//                                                              createDate: "2024-02-04T14:23:39",
//                                                              locationName: "대전",
//                                                              distance: 6.8,
//                                                              time: 6120,
//                                                              imageUrl: "",
//                                                              status: true,
//                                                              difficulty: "EASY_NORMAL",
//                                                              title: "")
//                          ])
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
