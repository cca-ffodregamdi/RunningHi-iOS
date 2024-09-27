//
//  TabBarReactor.swift
//  Presentation
//
//  Created by 유현진 on 9/27/24.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public class TabBarReactor: Reactor{
    
    public var initialState: State
    private let tabBarUseCase: TabBarUseCase
    
    public init(tabBarUseCase: TabBarUseCase) {
        self.initialState = State()
        self.tabBarUseCase = tabBarUseCase
    }
    
    public enum Action{
        case uploadFCMToken(String)
    }
    
    public enum Mutation{
        case tokenUploaded // 업로드 성공
        case tokenUploadFailed(Error) // 업로드 실패
    }
    
    public struct State{
        
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .uploadFCMToken(let fcmToken): return tabBarUseCase.uploadFCMToken(fcmToken: fcmToken).debug("uploadFCMToken").asObservable().map{Mutation.tokenUploaded}
                .catch { error in
                        .just(Mutation.tokenUploadFailed(error))
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .tokenUploadFailed(let error):
            print("failed uploadToken -> \(error)")
        case .tokenUploaded:
            print("success uploadToken")
        }
        return newState
    }
}

