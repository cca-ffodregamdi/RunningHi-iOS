//
//  FeedDetailModel.swift
//  Domain
//
//  Created by 유현진 on 6/8/24.
//

import Foundation

public struct FeedDetailModel: Decodable, Equatable{
    public let nickname: String
    public let profileImageUrl: String?
    public let level: Int
    public let postContent: String
    public let role: String
    public let locationName: String
    public let distance: Float
    public let time: Int
    public let meanPace: Int
    public let kcal: Int
    public let imageUrl: String?
    public let createDate: Date
    public var commentCount: Int
    public var likeCount: Int
    public let isOwner: Bool
    public var isLiked: Bool
    public var isBookmarked: Bool
    public var difficulty: FeedDetailDifficultyType
    
    public var routeList: [RouteInfo] = []
    public var sectionPace: [Int] = []
    public var sectionKcal: [Int] = []
    
    public static func == (lhs: FeedDetailModel, rhs: FeedDetailModel) -> Bool {
        return lhs.nickname == rhs.nickname &&
        lhs.profileImageUrl == rhs.profileImageUrl &&
        lhs.level == rhs.level &&
        lhs.postContent == rhs.postContent &&
        lhs.role == rhs.role &&
        lhs.locationName == rhs.locationName &&
        lhs.distance == rhs.distance &&
        lhs.time == rhs.time &&
        lhs.meanPace == rhs.meanPace &&
        lhs.kcal == rhs.kcal &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.createDate == rhs.createDate &&
        lhs.commentCount == rhs.commentCount &&
        lhs.likeCount == rhs.likeCount &&
        lhs.isOwner == rhs.isOwner &&
        lhs.isLiked == rhs.isLiked &&
        lhs.difficulty == rhs.difficulty &&
        lhs.isBookmarked == rhs.isBookmarked
    }
    
    public init(nickname: String, profileImageUrl: String?, level: Int, postContent: String, role: String, locationName: String, distance: Float, time: Int, meanPace: Int, kcal: Int, imageUrl: String?, createDate: Date, commentCount: Int, likeCount: Int, isOwner: Bool, isLiked: Bool, isBookmarked: Bool, difficulty: FeedDetailDifficultyType) {
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.level = level
        self.postContent = postContent
        self.role = role
        self.locationName = locationName
        self.distance = distance
        self.time = time
        self.meanPace = meanPace
        self.kcal = kcal
        self.imageUrl = imageUrl
        self.createDate = createDate
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.isOwner = isOwner
        self.isLiked = isLiked
        self.isBookmarked = isBookmarked
        self.difficulty = difficulty
    }
}

public enum FeedDetailDifficultyType: String, Decodable, CaseIterable {
    case VERYEASY
    case EASY
    case NORMAL
    case HARD
    case VERYHARD
    
    public var level: Int {
        switch self {
        case .VERYEASY:
            return 1
        case .EASY:
            return 2
        case .NORMAL:
            return 3
        case .HARD:
            return 4
        case .VERYHARD:
            return 5
        }
    }
}
