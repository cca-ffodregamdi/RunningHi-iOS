//
//  FeedCoordinatorInterface.swift
//  Presentation
//
//  Created by 유현진 on 6/5/24.
//

import Foundation
import Domain

public protocol FeedCoordinatorInterface{
    func showFeedDetail(viewController: FeedViewController, postId: Int)
    func showReportComment(commentId: Int)
    func showEditPost(viewController: FeedDetailViewController, postId: Int)
    func showEditComment(viewController: FeedDetailViewController, commentModel: CommentModel)
    func showBookmarkedFeed(viewController: FeedViewController)
    func showFeedDetailByBookmarkedFeed(viewController: FeedWithOptionViewController, postId: Int)
    func showDistanceFilter(viewController: FeedViewController, distanceState: DistanceFilter)
    func showSortFilter(viewController: FeedViewController, sortState: SortFilter)
    func showAnnounce()
    func showMapDetail(routeList: [RouteInfo])
}
