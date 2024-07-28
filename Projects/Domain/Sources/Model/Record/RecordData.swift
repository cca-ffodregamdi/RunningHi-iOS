//
//  RecordData.swift
//  Domain
//
//  Created by najin on 7/28/24.
//

import Foundation

public struct RecordData {
    public let chartDatas: [Double]
    public let totalTime: Int
    public let meanPace: Int
    public let totalKcal: Int
    public let runningRecords: [RunningRecordData]
}

public struct RunningRecordData: Decodable {
    public let postNo: Int?
    public let createDate: String?
    public let locationName: String?
    public let distance: Double?
    public let time: Int?
    public let imageUrl: String?
    public let status: Bool?
    public let difficulty: String?
    public let title: String?
}
