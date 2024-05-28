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
    
    public func fetchFeeds(page: Int, size: Int, keyword: [String]) -> Observable<[FeedModel]> {
        return service.rx.request(.fetchFeeds(page: page, size: size, keyword: keyword))
            .debug()
            .filterSuccessfulStatusCodes()
            .map{ response -> [FeedModel] in
                do{
                    let feedResponse = try JSONDecoder().decode(FeedResponseDTO.self, from: response.data)
                    return feedResponse.data.content
                }catch{
                    return []
                }
            }.asObservable()
            
    }
    
    
}
