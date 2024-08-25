//
//  MyCoordinatorInterface.swift
//  Presentation
//
//  Created by 유현진 on 6/6/24.
//

import Foundation
import Domain

public protocol MyCoordinatorInterface{
    func showNotice()
    func showNoticeDetail(noticeModel: NoticeModel)
    func showCustomerCenter()
    func showLevelHelp()
    func showAnnounce()
    func showMyFeed()
    func showFeedDetailByMyFeed(viewController: MyFeedViewController, postId: Int)
    func showEditProfile()
    func showSignOut()
}
