//
//  AccessDetailReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/9/24.
//

import Foundation
import ReactorKit
import RxSwift

public class AccessDetailReactor: Reactor{
    
    public enum Action{
        
    }
    
    public enum Mutation{
        
    }
    
    public struct State{
        let seletedIndex: Int
        let accessModels: [AccessModel] = [.service, .info, .location]
    }
    
    public var initialState: State
    
    public init(index: Int) {
        self.initialState = State(seletedIndex: index)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
