//
//  RecordDetailReactor.swift
//  Presentation
//
//  Created by najin on 8/18/24.
//

import Foundation
import ReactorKit
import Domain
import RxSwift
import Common

final public class RecordDetailReactor: Reactor {
    
    //MARK: - Properties
    
    public let initialState: State
    private let recordUseCase: RecordUseCase
    
    public enum Action{
        case fetchRecordDetailData(Int)
    }
    
    public enum Mutation{
        case setRecordDetailData(RunningResult)
    }
    
    public struct State{
        var runningResult: RunningResult?
    }
    
    //MARK: - Lifecycle
    
    public init(recordUseCase: RecordUseCase){
        self.initialState = State()
        self.recordUseCase = recordUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchRecordDetailData(let postNo):
            return recordUseCase.fetchRecordDetailData(postNo: postNo)
                .map { Mutation.setRecordDetailData($0) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setRecordDetailData(let runningResult):
            newState.runningResult = runningResult
        }
        return newState
    }
}
