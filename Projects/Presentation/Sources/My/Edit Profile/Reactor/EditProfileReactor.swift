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
        case fetchUserInfo
        case changeNickname(Bool)
        case selectedImage(Data)
        case deleteImage
        case editProfile
        case updateNickname(String?)
    }
    
    public enum Mutation{
        case updateIsLogout
        case updateIsSignOut
        case setUserInfo(MyUserInfoModel)
        case updateIsChangeNickname(Bool)
        case setSelectedImage(Data)
        case deleteProfileImage
        case updateSuccessedEditProfile
        case updateChangedNickname(String?)
    }
    
    public struct State{
        var isLogout: Bool = false
        var isSignOut: Bool = false
        var userInfo: MyUserInfoModel?
        var isChangedNickname: Bool = false
        var isChangedProfileImage: Bool = false
        var isDeleteProfileImage: Bool = false
        var successedEditProfile: Bool = false
        
        var changedNickname: String? 
        var selectedImage: Data?
    }
    
    public var initialState: State
    private let myUseCase: MyUseCase
    
    public init(myUseCase: MyUseCase) {
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchUserInfo: return myUseCase.fetchUserInfo().map{Mutation.setUserInfo($0)}
        case .logout: return Observable.just(Mutation.updateIsLogout)
        case .signOut:
            let loginTypeRawValue = UserDefaultsManager.get(forKey: .loginTypeKey) as! String
            return myUseCase.signOut(loginType: LoginType(rawValue: loginTypeRawValue)!).map{_ in Mutation.updateIsSignOut}
        case .changeNickname(let value):
            return Observable.just(Mutation.updateIsChangeNickname(value))
        case .updateNickname(let nickname):
            return Observable.just(Mutation.updateChangedNickname(nickname))
        case .selectedImage(let data):
            return Observable.just(Mutation.setSelectedImage(data))
        case .deleteImage:
            return Observable.just(Mutation.deleteProfileImage)
        case .editProfile:
            if currentState.isChangedNickname, currentState.isChangedProfileImage{
                return Observable.zip(myUseCase.editMyNickname(request: .init(nickname: currentState.changedNickname!)).asObservable(),
                                      myUseCase.editMyProfileImage(request: .init(jpegData: currentState.selectedImage!)).asObservable())
                .map{ _ in Mutation.updateSuccessedEditProfile}
            }else if currentState.isChangedNickname, currentState.isDeleteProfileImage{
                return Observable.zip(myUseCase.editMyNickname(request: .init(nickname: currentState.changedNickname!)).asObservable(),
                                      myUseCase.deleteMyProfileImage().asObservable())
                .map{ _ in Mutation.updateSuccessedEditProfile}
            }else if currentState.isChangedNickname{
                return myUseCase.editMyNickname(request: .init(nickname: currentState.changedNickname!)).map{_ in Mutation.updateSuccessedEditProfile}
            }else if currentState.isChangedProfileImage{
                return myUseCase.editMyProfileImage(request: .init(jpegData: currentState.selectedImage!)).map{_ in Mutation.updateSuccessedEditProfile}
            }else{
                return myUseCase.deleteMyProfileImage().map{_ in Mutation.updateSuccessedEditProfile }
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation{
        case .setUserInfo(let userInfoModel):
            newState.userInfo = userInfoModel
        case .updateIsLogout:
            UserDefaultsManager.reset()
            myUseCase.deleteKeyChain()
            newState.isLogout = true
        case .updateIsSignOut:
            UserDefaultsManager.reset()
            myUseCase.deleteKeyChain()
            newState.isSignOut = true
        case .updateIsChangeNickname(let value):
            newState.isChangedNickname = value
        case .updateChangedNickname(let nickname):
            newState.changedNickname = nickname
        case .setSelectedImage(let data):
            newState.selectedImage = data
            newState.isChangedProfileImage = true
        case .deleteProfileImage:
            newState.selectedImage = nil
            newState.isChangedProfileImage = false
            newState.isDeleteProfileImage = true
        case .updateSuccessedEditProfile:
            newState.successedEditProfile = true
        }
        
        return newState
    }
}
