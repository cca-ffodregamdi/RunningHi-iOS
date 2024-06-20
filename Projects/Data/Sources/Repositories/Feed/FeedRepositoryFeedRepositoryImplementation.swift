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
    
    public func fetchFeeds(page: Int) -> Observable<([FeedModel], Int)> {
        return service.rx.request(.fetchFeeds(page: page))
            .filterSuccessfulStatusCodes()
            .map{ response -> ([FeedModel], Int) in
                let feedResponse = try JSONDecoder().decode(FeedResponseDTO.self, from: response.data)
                return (feedResponse.data.content, feedResponse.data.totalPages)
            }
            .asObservable()
            .catch{ error in
                print("FeedRepositoryImplementation fetchFeeds error = \(error)")
                return Observable.error(error)
            }
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
    
    public func fetchComment(postId: Int, page: Int, size: Int = 10) -> Observable<([CommentModel], Int)> {
        return service.rx.request(.fetchComment(postId: postId, page: page))
            .filterSuccessfulStatusCodes()
            .map{ response -> ([CommentModel], Int) in
                let commentReponse = try JSONDecoder().decode(CommentsResponseDTO.self, from: response.data)
                return (commentReponse.data.content, commentReponse.data.totalPages)
            }.asObservable()
            .catch{ error in
                print("FeedRepositoryImplementation fetchComment error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func writeComment(commentModel: WriteCommentReqesutDTO) -> Observable<WriteCommentResponseModel> {
        return service.rx.request(.writeComment(commentModel: commentModel))
            .filterSuccessfulStatusCodes()
            .map{ response -> WriteCommentResponseModel in
                let writeCommentResponse = try JSONDecoder().decode(WriteCommentResponseDTO.self, from: response.data)
                return writeCommentResponse.data
            }.asObservable()
            .catch{ error in
                print("FeedRepositoryImplementation writeComment error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any> {
        return service.rx.request(.makeBookmark(post: post))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }
            .asObservable()
    }
    
    public func deleteBookmark(postId: Int) -> Observable<Any> {
        return service.rx.request(.deleteBookmark(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
    
    public func deleteComment(postId: Int) -> Observable<Any> {
        return service.rx.request(.deleteComment(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
}
