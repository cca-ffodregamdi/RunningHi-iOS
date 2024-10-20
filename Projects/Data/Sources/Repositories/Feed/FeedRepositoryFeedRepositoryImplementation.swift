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
    
    public func fetchFeeds(page: Int, size: Int, sort: String, distance: Int) -> Observable<([FeedModel], Int)> {
        return service.rx.request(.fetchFeeds(page: page, size: size ,sort: sort, distance: distance))
            .filterSuccessfulStatusCodes()
            .map{ response -> ([FeedModel], Int) in
                let feedResponse = try JSONDecoder().decode(FeedResponseDTO.self, from: response.data)
                return (feedResponse.data.content.map{$0.toEntity()}, feedResponse.data.totalPages)
            }
            .asObservable()
            .catch{ error in
                print("FeedRepositoryImplementation fetchFeeds error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchFeed(postId: Int) -> Observable<FeedModel> {
        return service.rx.request(.fetchFeed(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ response -> FeedModel in
                let feedResponse = try JSONDecoder().decode(OneOfFeedResponseDTO.self, from: response.data)
                return feedResponse.data.toEntity()
            }.asObservable()
            .catch{ error in
                print("FeedRepositoryImplementation fetchFeed error = \(error)")
                return Observable.error(error)
            }
        
    }
    
    public func fetchFeedDetail(postId: Int) -> Observable<FeedDetailModel> {
        return service.rx.request(.fetchPost(postId: postId))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .flatMap { response -> Observable<FeedDetailModel> in
                do {
                    // 1. FeedDetailResponseDTO 디코딩
                    let feedDetailResponse = try JSONDecoder().decode(FeedDetailResponseDTO.self, from: response.data)
                    var feedDetailModel = feedDetailResponse.data.toEntity()
                    
                    // 2. GPS URL이 있을 경우 getRunningRouteData 호출
                    return self.getRunningRouteData(url: feedDetailResponse.data.gpsUrl ?? "")
                        .map { gpsData in
                            // 3. GPS 데이터를 FeedDetailModel에 추가
                            feedDetailModel.routeList = gpsData.gpsData?.compactMap { data in
                                return RouteInfo(
                                    latitude: Double(data.lat) ?? 0.0,
                                    longitude: Double(data.lon) ?? 0.0,
                                    timestamp: Date.formatDateStringToDate(dateString: data.time) ?? Date()
                                )
                            } ?? []
                            feedDetailModel.sectionPace = gpsData.sectionData?.pace ?? []
                            feedDetailModel.sectionKcal = gpsData.sectionData?.kcal ?? []
                            return feedDetailModel
                        }
                    
                } catch {
                    return Observable.error(error)
                }
            }
            .catch { error in
                print("FeedRepositoryImplementation fetchFeedDetail error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchComment(postId: Int) -> Observable<[CommentModel]> {
        return service.rx.request(.fetchComment(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ response -> [CommentModel] in
                let commentReponse = try JSONDecoder().decode(CommentsResponseDTO.self, from: response.data)
                return commentReponse.data.content.map{$0.toEntity()}
            }.asObservable()
            .catch{ error in
                print("FeedRepositoryImplementation fetchComment error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func writeComment(commentModel: WriteCommentReqesutModel) -> Single<WriteCommentModel> {
        return service.rx.request(.writeComment(commentModel: commentModel))
            .filterSuccessfulStatusCodes()
            .map{ response -> WriteCommentModel in
                let writeCommentResponse = try JSONDecoder().decode(WriteCommentResponseDTO.self, from: response.data)
                return writeCommentResponse.data.toEntity()
            }.catch{ error in
                print("FeedRepositoryImplementation writeComment error = \(error)")
                return Single.error(error)
            }
    }
    
    public func makeBookmark(post: BookmarkRequestModel) -> Observable<Any> {
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
    
    public func reportComment(reportCommentModel: ReportCommentRequestModel) -> Observable<Any> {
        return service.rx.request(.reportComment(reportCommentModel: reportCommentModel))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
    
    public func deletePost(postId: Int) -> Observable<Any> {
        return service.rx.request(.deletePost(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
    
    public func editPost(postId: Int, editPostModel: EditFeedRequestModel) -> Observable<Any> {
        return service.rx.request(.editPost(postId: postId, editPostModel: editPostModel))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
    
    public func likePost(likePost: FeedLikeRequestModel) -> Observable<FeedLikeModel> {
        return service.rx.request(.likePost(likePost: likePost))
            .filterSuccessfulStatusCodes()
            .map{ response -> FeedLikeModel in
                let feedLikeResponse = try JSONDecoder().decode(FeedLikeResponseDTO.self, from: response.data)
                return feedLikeResponse.data.toEntity()
            }.asObservable()
            .catch { error in
                print("FeedRepositoryImplementation likePost error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func unLikePost(postId: Int) -> Observable<FeedLikeModel> {
        return service.rx.request(.unLikePost(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ response -> FeedLikeModel in
                let feedLikeResponse = try JSONDecoder().decode(FeedLikeResponseDTO.self, from: response.data)
                return feedLikeResponse.data.toEntity()
            }.asObservable()
            .catch { error in
                print("FeedRepositoryImplementation unLikePost error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func editComment(commentId: Int, editCommentModel: EditCommentRequestModel) -> Observable<Any> {
        return service.rx.request(.editComment(commentId: commentId, editCommentModel: editCommentModel))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
    
    public func fetchOptionFeed(page: Int, size: Int, option: FeedOptionType) -> Observable<([FeedModel], Int)> {
        switch option{
        case .bookmark:
            return service.rx.request(.fetchBookmarkedFeeds(pages: page, size: size))
                .filterSuccessfulStatusCodes()
                .map{ response -> ([FeedModel], Int) in
                    let feedResponse = try JSONDecoder().decode(FeedResponseDTO.self, from: response.data)
                    return (feedResponse.data.content.map{$0.toEntity()}, feedResponse.data.totalPages)
                }
                .asObservable()
                .catch{ error in
                    print("FeedRepositoryImplementation fetchBookmarkedFeeds error = \(error)")
                    return Observable.error(error)
                }
        case .myFeed:
            return service.rx.request(.fetchMyFeed(page: page, size: size))
                .filterSuccessfulStatusCodes()
                .map{ response -> ([FeedModel], Int) in
                    let feedResponse = try JSONDecoder().decode(FeedResponseDTO.self, from: response.data)
                    return (feedResponse.data.content.map{$0.toEntity()}, feedResponse.data.totalPages)
                }
                .asObservable()
                .catch{ error in
                    print("FeedRepositoryImplementation fetchMyFeed error = \(error)")
                    return Observable.error(error)
                }
        }
    }
    
    public func saveFeedImage(image: Data) -> Observable<String> {
        return service.rx.request(.saveRunningImage(image: image))
            .filterSuccessfulStatusCodes()
            .map{ response -> String in
                let responseDTO = try JSONDecoder().decode(FeedImageResponseDTO.self, from: response.data)
                return responseDTO.data
            }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    public func saveFeed(feedModel: EditFeedModel, imageURL: String) -> Observable<Void> {
        let requestDTO = CreateFeedRequestDTO(postNo: feedModel.postNo, postContent: feedModel.postContent, difficulty: "",                                            mainData: feedModel.mainData.typeNo, imageUrl: imageURL)
        return service.rx.request(.createFeed(feedData: requestDTO))
            .filterSuccessfulStatusCodes()
            .map{ response -> Void in
                let _ = try JSONDecoder().decode(FeedEditResponseDTO.self, from: response.data)
                return
            }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    public func editFeed(feedModel: EditFeedModel, imageURL: String) -> Observable<Void> {
        let requestDTO = EditFeedRequestModel(postContent: feedModel.postContent, dataType: feedModel.mainData.typeNo, imageUrl: imageURL)
        return service.rx.request(.editFeed(postNo: feedModel.postNo, feedData: requestDTO))
            .filterSuccessfulStatusCodes()
            .map{ response -> Void in
                let _ = try JSONDecoder().decode(FeedEditResponseDTO.self, from: response.data)
                return
            }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    private func getRunningRouteData(url: String) -> Observable<RunningResultDTO> {
        return service.rx.request(.fetchGPSData(url: url))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(RunningResultDTO.self)
    }
}
