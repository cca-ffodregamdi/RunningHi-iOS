//
//  FeedUseCaseProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import RxSwift

protocol FeedUseCaseProtocol{
    func fetchFeeds(page: Int) -> Observable<[FeedModel]>
    func fetchPost(postId: Int) -> Observable<FeedDetailModel>
    func fetchComment(postId: Int) -> Observable<[CommentModel]>
    func writeComment(commentModel: WriteCommentReqesutDTO) -> Observable<WriteCommentResponseModel>
}
