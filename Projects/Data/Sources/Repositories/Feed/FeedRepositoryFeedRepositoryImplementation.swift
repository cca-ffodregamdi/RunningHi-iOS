//
//  FeedRepository.swift
//  Data
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import Domain
import RxSwift
import Moya
import RxMoya

public final class FeedRepositoryImplementation: FeedRepositoryProtocol{
    
    private let service = MoyaProvider<FeedService>()
    
    public init(){ }
    
    public func fetchFeeds(page: Int) -> Observable<[FeedModel]> {
        return service.rx.request(.fetchFeeds(page: page))
            .filterSuccessfulStatusCodes()
            .map{ response -> [FeedModel] in
                do{
                    let feedResponse = try JSONDecoder().decode(FeedResponseDTO.self, from: response.data)
                    return feedResponse.data.content
                }catch let error{
                    print("FeedRepositoryImplementation fetchFeeds error = \(error)")
                    return []
                }
            }
            .asObservable()
    }
    
    public func fetchPost(postId: Int) -> Observable<FeedDetailModel> {
        return service.rx.request(.fetchPost(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ response -> FeedDetailModel in
                    let feedDetailResponse = try JSONDecoder().decode(FeedDetailResponseDTO.self, from: response.data)
                    return feedDetailResponse.data
            }.asObservable()
            .catch { error in
                print("FeedRepositoryImplementation fetchPost error = \(error)")
                return Observable.error(error)
            }
    }
}
