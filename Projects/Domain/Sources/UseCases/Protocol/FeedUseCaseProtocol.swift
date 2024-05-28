//
//  FeedUseCaseProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import RxSwift

protocol FeedUseCaseProtocol{
    func fetchFeeds(page: Int, size: Int, keyword: [String]) -> Observable<[FeedModel]>
}
