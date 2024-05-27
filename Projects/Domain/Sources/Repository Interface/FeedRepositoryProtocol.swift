//
//  FeedRepositoryProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import Moya
import RxSwift

public protocol FeedRepositoryProtocol{
    func fetchFeeds(page: Int, size: Int, keyword: [String]) -> Observable<[FeedModel]>
}
