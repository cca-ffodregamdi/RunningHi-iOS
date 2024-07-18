//
//  NoticeReactor.swift
//  Presentation
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import ReactorKit
import Domain

public class NoticeReactor: Reactor{
    public enum Action{
        case fetchNotice
    }
    
    public enum Mutation{
        case setNotices([NoticeModel])
    }
    
    public struct State{
        var notices: [NoticeModel] = []
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    
    public init(myUseCase: MyUseCase) {
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchNotice: myUseCase.fetchNotice().map{ Mutation.setNotices($0) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setNotices(let notices):
            newState.notices = notices
        }
        return newState
    }
}
