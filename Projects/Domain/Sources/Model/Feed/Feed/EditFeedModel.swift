//
//  EditFeedModel.swift
//  Domain
//
//  Created by najin on 8/25/24.
//

import Foundation

public struct EditFeedModel {
    public var postNo: Int
    public var postContent: String
    public var mainData: FeedRepresentType
    public var imageUrl: String
    
    public init(postNo: Int, postContent: String, mainData: FeedRepresentType, imageUrl: String) {
        self.postNo = postNo
        self.postContent = postContent
        self.mainData = mainData
        self.imageUrl = imageUrl
    }
}
