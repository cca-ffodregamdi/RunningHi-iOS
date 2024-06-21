//
//  ReportCommentReactor.swift
//  Presentation
//
//  Created by 유현진 on 6/21/24.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public class ReportCommentReactor: Reactor{
    public enum Action{
        case fetchCell
        case selectedType(Int)
    }
    
    public enum Mutation{
        case setItems([ReportCommentType])
        case setSelectedTypeIndex(Int)
    }
    
    public struct State{
        var commentId: Int
        var seletedTypeIndex: Int = -1
        var items: [ReportCommentType] = []
    }
    
    public var initialState: State
    private var feedUsecase: FeedUseCase
    
    public init(feedUsecase: FeedUseCase, commentId: Int){
        self.feedUsecase = feedUsecase
        self.initialState = State(commentId: commentId)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchCell:
            let items: [ReportCommentType] = [
                .spam,
                .illegal,
                .adultContent,
                .abuse,
                .privacy,
                .other
            ]
            return .just(Mutation.setItems(items))
            
        case .selectedType(let index):
            return .just(Mutation.setSelectedTypeIndex(index))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setItems(let items):
            newState.items = items
        case .setSelectedTypeIndex(let index):
            newState.seletedTypeIndex = index
            print(index)
        }
        return newState
    }
}
