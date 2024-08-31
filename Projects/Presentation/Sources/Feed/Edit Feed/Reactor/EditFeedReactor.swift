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
        case createRunningFeed(EditFeedModel)
        case tapRepresentButton(FeedRepresentType)
        case selectedImage(Data?)
    }
    
    public enum Mutation{
        case finishCreateRunningFeed
        case setFeedRepresentType(FeedRepresentType)
        case setSelectedImage(Data?)
    }
    
    public struct State{
        var isFinishCreateRunningFeed = false
        var representType: FeedRepresentType?
        var selectedImage: Data?
    }
    
    //MARK: - Lifecycle
    
    public init(feedUseCase: FeedUseCase) {
        self.initialState = State()
        self.feedUseCase = feedUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .createRunningFeed(let feedModel):
            return feedUseCase.editFeed(feedModel: feedModel, selectedImage: currentState.selectedImage)
                .map { Mutation.finishCreateRunningFeed }
        case .tapRepresentButton(let type):
            return Observable.just(Mutation.setFeedRepresentType(type))
        case .selectedImage(let image):
            return Observable.just(Mutation.setSelectedImage(image))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .finishCreateRunningFeed:
            newState.isFinishCreateRunningFeed = true
        case .setFeedRepresentType(let type):
            newState.representType = type
        case .setSelectedImage(let image):
            newState.selectedImage = image
        }
        return newState
    }
}
