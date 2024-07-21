//
//  RecordReactor.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import Foundation
import ReactorKit
import Domain
import RxSwift

final public class RecordReactor: Reactor {
    
    //MARK: - Properties
    
    public let initialState: State
    private let recordUseCase: RecordUseCase
    
    public enum Action{
        
    }
    
    public enum Mutation{
        
    }
    
    public struct State{
        
    }
    
    //MARK: - Lifecycle
    
    public init(recordUseCase: RecordUseCase){
        self.initialState = State()
        self.recordUseCase = recordUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        
        }
        return newState
    }
}
