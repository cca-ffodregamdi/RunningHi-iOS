//
//  EditProfileReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/23/24.
//

import Foundation
import RxSwift
import ReactorKit
import Domain
import Common

public class EditProfileReactor: Reactor{
    public enum Action{
        case logout
        case signOut
    }
    
    public enum Mutation{
        case updateIsLogout
        case updateIsSignOut
    }
    
    public struct State{
        var isLogout: Bool = false
        var isSignOut: Bool = false
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    
    public init(myUseCase: MyUseCase) {
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .logout: return Observable.just(Mutation.updateIsLogout)
        case .signOut:
            let loginTypeRawValue = UserDefaultsManager.get(forKey: .loginTypeKey) as! String
            return myUseCase.signOut(loginType: LoginType(rawValue: loginTypeRawValue)!).map{_ in Mutation.updateIsSignOut}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation{
        case .updateIsLogout:
            UserDefaultsManager.reset()
            myUseCase.deleteKeyChain()
            newState.isLogout = true
        case .updateIsSignOut:
            UserDefaultsManager.reset()
            myUseCase.deleteKeyChain()
            newState.isSignOut = true
        }
        
        return newState
    }
}
