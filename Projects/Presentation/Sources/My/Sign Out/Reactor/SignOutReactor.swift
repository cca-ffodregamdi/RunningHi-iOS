//
//  SignOutReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/24/24.
//

import Foundation
import RxSwift
import ReactorKit
import Domain

public class SignOutReactor: Reactor{
    public enum Action{
        case selectedSection(Int)
    }
    
    public enum Mutation{
        case updateSelectedIndex(Int)
    }
    
    public struct State{
        let reasonList: [SignOutReasonSection] = [
            .init(items: [.unusable]),
            .init(items: [.difficult]),
            .init(items: [.doNotRun]),
            .init(items: [.lowMethod]),
            .init(items: [.etc])
        ]
        var selectedSectionIndex: Int?
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    
    public init(myUseCase: MyUseCase) {
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .selectedSection(let index): Observable.just(Mutation.updateSelectedIndex(index))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation{
        case .updateSelectedIndex(let index):
            newState.selectedSectionIndex = index
        }
        return newState
    }
}
