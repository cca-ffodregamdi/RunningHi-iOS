//
//  FeedItem.swift
//  Presentation
//
//  Created by 유현진 on 6/26/24.
//

import Foundation
import RxDataSources
import Domain

extension FeedModel: IdentifiableType, Equatable{

    public var identity: Int {
        return postId
    }
    
    public static func == (lhs: FeedModel, rhs: FeedModel) -> Bool {
        return lhs.postId == rhs.postId &&
        lhs.isBookmarked == rhs.isBookmarked &&
        lhs.likeCount == rhs.likeCount &&
        lhs.commentCount == rhs.commentCount
    }
    
}
