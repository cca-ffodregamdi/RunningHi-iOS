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
        case viewDidLoad
        case tapChartType(RecordChartType)
        case tapChartRangeButton(Int)
        case tapChartDateButton(Date)
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
            
        case .viewDidLoad:
            return recordUseCase.fetchRecordData(type: .weekly, date: Date())
                .map { Mutation.setRecordData($0) }
            
        case .tapChartType(let type):
            return recordUseCase.fetchRecordData(type: type, date: Date())
                .map { Mutation.setRecordData($0) }
            
        case .tapChartRangeButton(let increasement):
            let chartType = currentState.recordData?.chartType ?? .weekly
            let chartDate = currentState.recordData?.date ?? Date()
            let rangedDate = DateUtil.getRangedDate(increase: increasement,type: chartType.calendarType,date: chartDate)
            
            // 아직 오지 않은 날짜의 차트는 볼 수 없음
            if DateUtil.isDateInFuture(type: chartType.calendarType, date: rangedDate) { return Observable.empty() }
            
            return recordUseCase.fetchRecordData(type: chartType, date: rangedDate)
                .map { Mutation.setRecordData($0) }
        
        case .tapChartDateButton(let date):
            let chartType = currentState.recordData?.chartType ?? .weekly
            
            return recordUseCase.fetchRecordData(type: chartType, date: date)
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
