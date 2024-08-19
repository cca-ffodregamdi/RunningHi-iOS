//
//  MyReactor.swift
//  Presentation
//
//  Created by 유현진 on 5/19/24.
//

import Foundation
import ReactorKit
import RxDataSources
import Domain

final public class MyReactor: Reactor{
    
    public enum Action{
        case fetchUserInfo
    }
    
    public enum Mutation{
        case setUserInfo(MyUserInfoModel)
    }
    
    public struct State{
        var items: [MyPageItem] = [
            .myFeed,
            .notices,
            .setting,
            .customerCenter,
            .logOut
        ]
        var userInfo: MyUserInfoModel?
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    public init(myUseCase: MyUseCase){
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchUserInfo: myUseCase.fetchUserInfo().map{Mutation.setUserInfo($0)}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setUserInfo(let userInfoModel):
            newState.userInfo = userInfoModel
        }
        return newState
    }
}
