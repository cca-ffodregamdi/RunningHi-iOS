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
        
    }
    
    public enum Mutation{
        
    }
    
    public struct State{
        
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    
    public init(myUseCase: MyUseCase) {
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
