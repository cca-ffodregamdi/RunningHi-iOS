//
//  RecordResponseDTO.swift
//  Domain
//
//  Created by najin on 7/28/24.
//

import Foundation

public struct RecordResponseDTO: Decodable {
    let timeStamp: String
    let status: String
    let message: String
    public let data: WeeklyRecordDataDTO
}

public struct WeeklyRecordDataDTO: Decodable {
    public let weeklyRecordData: [Double]?
    public let totalTime: Int?
    public let meanPace: Int?
    public let totalKcal: Int?
    public let recordPostList: [RecordPostListDTO]
    
    public var toEntity: RecordData {
        return RecordData(chartDatas: weeklyRecordData ?? [],
                          totalTime: totalTime ?? 0,
                          meanPace: meanPace ?? 0,
                          totalKcal: totalKcal ?? 0,
                          runningRecords: recordPostList.map{$0.toEntity})
    }
}

public struct RecordPostListDTO: Decodable {
    public let postNo: Int?
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
                                 createDate: createDate,
                                 locationName: locationName,
                                 distance: distance,
                                 time: time,
                                 imageUrl: imageUrl,
                                 status: status,
                                 difficulty: difficulty,
                                 title: title)
    }
}
