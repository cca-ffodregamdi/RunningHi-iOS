//
//  CustomerCenterReactor.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public class CustomerCenterReactor: Reactor{
    public enum Action{
        case setMode(CustomerCenterMode)
        case fetchFAQ
        case fetchFeedback
        case toggleExpand(IndexPath)
    }
    
    public enum Mutation{
        case FAQMode
        case FeedbackMode
        case setSection([CustomerCenterSectionModel])
        case toggleExpand(IndexPath)
    }
    
    public struct State{
        var mode: CustomerCenterMode = .FAQ
        var faqModel: [FAQModel] = []
        var feedbackModel: [FeedbackModel] = []
        var sections: [CustomerCenterSectionModel] = []
        var expandedIndex: Set<IndexPath> = []
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    public init(myUseCase: MyUseCase) {
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .setMode(let mode):
            switch mode{
            case .FAQ:
                return Observable.just(Mutation.FAQMode)
            case .Feedback:
                return Observable.just(Mutation.FeedbackMode)
            }
        case .fetchFAQ: 
            return myUseCase.fetchFAQ().map{ faqModels in
                let faqItems = faqModels.map{CustomerCenterItemType.faq($0)}
                let faqSection = CustomerCenterSectionModel(header: "자주 묻는 질문", items: faqItems)
                return Mutation.setSection([faqSection])
            }
        case .fetchFeedback:
            return myUseCase.fetchFeedback().map{ feedbackModels in
                let feedbackItems = feedbackModels.map{CustomerCenterItemType.feedback($0)}
                let feedbackSection = CustomerCenterSectionModel(header: "1:1 문의", items: feedbackItems)
                return Mutation.setSection([feedbackSection])
            }
        case .toggleExpand(let indexPath):
            return .just(.toggleExpand(indexPath))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .FAQMode:
            newState.mode = .FAQ
        case .FeedbackMode:
            newState.mode = .Feedback
        case .setSection(let sections):
            newState.sections = sections
        case .toggleExpand(let indexPath):
            if newState.expandedIndex.contains(indexPath){
                newState.expandedIndex.remove(indexPath)
            }else{
                newState.expandedIndex.insert(indexPath)
            }
        }
        return newState
    }
}
