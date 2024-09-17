//
//  EditFeedReactor.swift
//  Presentation
//
//  Created by 유현진 on 6/26/24.
//

import Foundation
import ReactorKit
import Domain

public class EditFeedReactor: Reactor{
    
    //MARK: - Properties
    
    public let initialState: State
    private let feedUseCase: FeedUseCase
    
    public enum Action{
        case fetchFeedDetail
        case createRunningFeed(EditFeedModel)
        case editRunningFeed(EditFeedModel)
        case tapRepresentButton(FeedRepresentType)
        case selectedImage(Data?)
    }
    
    public enum Mutation{
        case setFeedDetail(FeedDetailModel)
        case finishCreateRunningFeed
        case setFeedRepresentType(FeedRepresentType)
        case setSelectedImage(Data?)
    }
    
    public struct State{
        var postNo: Int
        var enterType: EditFeedEnterType
        var isPosted: Bool
        
        var isFinishCreateRunningFeed = false
        var selectedImage: Data?
        
        var postContent: String?
        var postImageURL: String = ""
        var representType: FeedRepresentType?
    }
    
    //MARK: - Lifecycle
    
    public init(feedUseCase: FeedUseCase, postNo: Int, enterType: EditFeedEnterType, isPosted: Bool) {
        self.initialState = State(postNo: postNo, enterType: enterType, isPosted: isPosted)
        self.feedUseCase = feedUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchFeedDetail:
            return feedUseCase.fetchPost(postId: currentState.postNo)
                .map { feedDetailModel in
                    Mutation.setFeedDetail(feedDetailModel)
                }
        case .createRunningFeed(let feedModel):
            if let selectedImage = currentState.selectedImage {
                // 이미지를 설정한 경우 (이미지 저장 API -> 피드 저장 API)
                return feedUseCase.saveFeedImage(image: selectedImage)
                    .flatMap { feedImageURL in
                        return self.feedUseCase.saveFeed(feedModel: feedModel, imageURL: feedImageURL)
                    }
                    .map { Mutation.finishCreateRunningFeed }
            } else {
                // 이미지를 설정하지 않은 경우 (피드 저장 API)
                return feedUseCase.saveFeed(feedModel: feedModel, imageURL: "")
                    .map { Mutation.finishCreateRunningFeed }
            }
        case .editRunningFeed(let feedModel):
            if let selectedImage = currentState.selectedImage {
                // 이미지를 설정한 경우 (이미지 저장 API -> 피드 저장 API)
                return feedUseCase.saveFeedImage(image: selectedImage)
                    .flatMap { feedImageURL in
                        return self.feedUseCase.editFeed(feedModel: feedModel, imageURL: feedImageURL)
                    }
                    .map { Mutation.finishCreateRunningFeed }
            } else {
                // 이미지를 설정하지 않은 경우 (피드 저장 API)
                return feedUseCase.editFeed(feedModel: feedModel, imageURL: currentState.postImageURL)
                    .map { Mutation.finishCreateRunningFeed }
            }
        case .tapRepresentButton(let type):
            return Observable.just(Mutation.setFeedRepresentType(type))
        case .selectedImage(let image):
            return Observable.just(Mutation.setSelectedImage(image))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setFeedDetail(let model):
            newState.postContent = model.postContent
            newState.postImageURL = model.imageUrl ?? ""
            newState.representType = model.mainData
        case .finishCreateRunningFeed:
            newState.isFinishCreateRunningFeed = true
        case .setFeedRepresentType(let type):
            newState.representType = type
        case .setSelectedImage(let image):
            newState.postImageURL = ""
            newState.selectedImage = image
        }
        return newState
    }
}
