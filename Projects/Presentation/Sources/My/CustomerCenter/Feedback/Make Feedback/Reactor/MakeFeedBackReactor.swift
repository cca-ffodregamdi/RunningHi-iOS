//
//  MakeFeedBackReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/26/24.
//

import Foundation
import ReactorKit
import Domain

public class MakeFeedBackReactor: Reactor{
    public enum Action{
        case selectFeedbackCategory(FeedbackCategory)
        case resetSelectedFeedbackCategory
        case isExistFeedbackTitle(Bool)
        case isExistFeedbackContent(Bool)
        case makeFeedback(MakeFeedbackRequestModel)
    }
    
    public enum Mutation{
        case updateSelectedFeedbackCategory(FeedbackCategory)
        case resetSelectedFeedbackCategory
        case updateIsExitFeedbackTitle(Bool)
        case updateIsExitFeedbackContent(Bool)
        case successMakeFeedback
    }
    
    public struct State{
        let feedbackCategory: [FeedbackCategory] = [.INQUIRY, .PROPOSAL, .WEBERROR, .ROUTEERROR, .POSTERROR]
        var selectedFeedbackCategory: FeedbackCategory?
        var isExistFeedbackTitle: Bool = false
        var isExistFeedbackContent: Bool = false
        var successedMadeFeedback: Bool = false
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    
    public init(myUseCase: MyUseCase) {
        self.initialState = State()
        self.myUseCase = myUseCase
        
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .selectFeedbackCategory(let category): Observable.just(Mutation.updateSelectedFeedbackCategory(category))
        case .resetSelectedFeedbackCategory: Observable.just(.resetSelectedFeedbackCategory)
        case .isExistFeedbackTitle(let value):
            Observable.just(Mutation.updateIsExitFeedbackTitle(value))
        case .isExistFeedbackContent(let value):
            Observable.just(Mutation.updateIsExitFeedbackContent(value))
        case .makeFeedback(let request):
            myUseCase.makeFeedback(request: request).map{_ in Mutation.successMakeFeedback}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newSate = state
        switch mutation{
        case .updateSelectedFeedbackCategory(let category):
            newSate.selectedFeedbackCategory = category
        case .resetSelectedFeedbackCategory:
            newSate.selectedFeedbackCategory = nil
        case .updateIsExitFeedbackTitle(let value):
            newSate.isExistFeedbackTitle = value
        case .updateIsExitFeedbackContent(let value):
            newSate.isExistFeedbackContent = value
        case .successMakeFeedback:
            newSate.successedMadeFeedback = true
        }
        return newSate
    }
}
