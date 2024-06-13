//
//  FeedUseCase.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import RxSwift

public final class FeedUseCase: FeedUseCaseProtocol{
    
    private let repository: FeedRepositoryProtocol

    public init(repository: FeedRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchFeeds(page: Int) -> Observable<[FeedModel]> {
        return repository.fetchFeeds(page: page)
    }
    
    public func fetchPost(postId: Int) -> Observable<FeedDetailModel> {
        return repository.fetchPost(postId: postId)
    }
    
    public func fetchComment(postId: Int) -> Observable<[CommentModel]> {
        return  repository.fetchComment(postId: postId)
    }
    
    public func writeComment(commentModel: WriteCommentReqesutDTO) -> Observable<WriteCommentResponseModel> {
        return repository.writeComment(commentModel: commentModel)
    }
}
