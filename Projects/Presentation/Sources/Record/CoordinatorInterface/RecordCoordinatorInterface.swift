//
//  RecordCoordinatorInterface.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import Foundation
import Domain

public protocol RecordCoordinatorInterface {
    func showRecordDetail(postNo: Int, isPosted: Bool)
    func showEditFeed(postNo: Int, isPosted: Bool)
}
