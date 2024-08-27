//
//  FeedbackDetailReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/26/24.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public class FeedbackDetailReactor: Reactor{
    public enum Action{
        case fetchFeedbackDetail
    }
    
    public enum Mutation{
        case setFeedbackDetailModel(FeedbackDetailModel)
    }
    
    public struct State{
        let feedbackId: Int
        var feedbackDetailModel: FeedbackDetailModel?
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    
    public init(feedbackId: Int, myUseCase: MyUseCase) {
        self.initialState = State(feedbackId: feedbackId)
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchFeedbackDetail: myUseCase.fetchFeedbackDetail(feedbackId: currentState.feedbackId).map{Mutation.setFeedbackDetailModel($0)}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setFeedbackDetailModel(let model):
            newState.feedbackDetailModel = model
        }
        return newState
    }
}
