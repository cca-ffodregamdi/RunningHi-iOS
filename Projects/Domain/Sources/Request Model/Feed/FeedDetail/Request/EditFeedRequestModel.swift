//
//  EditFeedRequestModel.swift
//  Domain
//
//  Created by 유현진 on 6/26/24.
//

import Foundation
//    0: 거리
//    1: 시간
//    2: 칼로리
//    3: 평균페이스
public struct EditFeedRequestModel: Codable{
    let postContent: String
    let mainData: Int
    let imageUrl: String
    
    public init(postContent: String, dataType: Int, imageUrl: String) {
        self.postContent = postContent
        self.mainData = dataType
        self.imageUrl = imageUrl
    }
}
