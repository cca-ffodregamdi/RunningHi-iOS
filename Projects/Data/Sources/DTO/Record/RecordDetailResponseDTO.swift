//
//  RecordDetailResponseDTO.swift
//  Data
//
//  Created by najin on 8/18/24.
//

import Foundation
import Domain

public struct RecordDetailResponseDTO: Decodable {
    let timeStamp: String
    let status: String
    let message: String
    
    public let data: RecordDetailDataDTO
}

public struct RecordDetailDataDTO: Decodable {
    public let nickname: String?
    public let profileImageUrl: String?
    public let level: Int?
    public let createDate: String?
    public let postContent: String?
    public let role: String?
    public let owner: Bool?
    public let locationName: String?
    public let distance: Double?
    public let time: Int?
    public let meanPace: Int?
    public let kcal: Int?
    public let imageUrl: String?
    public let likeCnt: Int?
    public let bookmarkCnt: Int?
    public let replyCnt: Int?
    public let difficulty: String?
    public let isLiked: Bool?
    public let isBookmarked: Bool?
    public let gpsUrl: String?
    
    public func toEntity(postNo: Int) -> RunningResult {
        let startTime = Date.formatDateStringToDate(dateString: createDate ?? "") ?? Date()
        return RunningResult(startTime: startTime,
                             time: time ?? 0,
                             location: locationName ?? "",
                             difficulty: FeedDetailDifficultyType.allCases.filter{$0.rawValue == difficulty}.first ?? FeedDetailDifficultyType.NORMAL,
                             runningTime: time ?? 0,
                             distance: distance ?? 0,
                             averagePace: meanPace ?? 0,
                             calorie: kcal ?? 0
        )
    }
}
