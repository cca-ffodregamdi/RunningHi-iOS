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
        case deleteRunningRecord(Int)
    }
    
    public enum Mutation{
        case setRecordDetailData(RunningResult)
        case finishDeleteRunningRecord
    }
    
    public struct State{
        var postNo: Int
        var isPosted: Bool
        
        var runningResult: RunningResult?
        var isFinishDeleteRunningRecord = false
    }
    
    //MARK: - Lifecycle
    
    public init(recordUseCase: RecordUseCase, postNo: Int, isPosted: Bool){
        self.initialState = State(postNo: postNo, isPosted: isPosted)
        self.recordUseCase = recordUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchRecordDetailData(let postNo):
            return recordUseCase.fetchRecordDetailData(postNo: postNo)
                .map { Mutation.setRecordDetailData($0) }
        case .deleteRunningRecord(let postNo):
            return recordUseCase.deleteRunningRecord(postNo: postNo)
                .map { Mutation.finishDeleteRunningRecord }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setRecordDetailData(let runningResult):
            newState.runningResult = runningResult
        case .finishDeleteRunningRecord:
            newState.isFinishDeleteRunningRecord = true
        }
        return newState
    }
}
