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
import Common

final public class RecordReactor: Reactor {
    
    //MARK: - Properties
    
    public let initialState: State
    private let recordUseCase: RecordUseCase
    
    public enum Action{
        case tapChartType(RecordChartType, Date = Date())
    }
    
    public enum Mutation{
        case setRecordData(RecordData)
    }
    
    public struct State{
        var recordData: RecordData?
    }
    
    //MARK: - Lifecycle
    
    public init(recordUseCase: RecordUseCase){
        self.initialState = State()
        self.recordUseCase = recordUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .tapChartType(let type, let date):
            return recordUseCase.fetchRecordData(type: type, date: date)
                .map { Mutation.setRecordData($0) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setRecordData(let data):
            newState.recordData = data
        }
        return newState
    }
}
