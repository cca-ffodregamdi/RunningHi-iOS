//
//  AccessReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/7/24.
//

import Foundation
import RxSwift
import ReactorKit
import Domain

public class AccessReactor: Reactor{
    public enum Action{
        case checkRow(Int)
        case touchUpCheckAllButton
        case signIn
        case checkAuthorization
        case readCurrentLocation
    }
    
    public enum Mutation{
        case changeCheckArray(Int)
        case checkAllToggle
        case signed(String, String)
        case setAuthorization(LocationAuthorizationStatus?)
        case setCurrentLocation(RouteInfo)
        case successedUploadUserLocation
    }
    
    public struct State{
        let accessModel: [String] = ["서비스 이용 약관 (필수)", "개인정보 수집/이용 동의서 (필수)", "위치정보 이용약관 (필수)"]
        var checkArray: [Bool] = [false, false, false]
        var checkAllState: Bool = false
        var successedSignIn: Bool = false
        var authorization: LocationAuthorizationStatus?
        var currentLocation: RouteInfo?
    }
    
    public var initialState: State
    private let loginUseCase: LoginUseCase
    
    public init(loginUseCase: LoginUseCase) {
        self.initialState = State()
        self.loginUseCase = loginUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .checkRow(let index):
            return Observable.just(Mutation.changeCheckArray(index)).observe(on: MainScheduler.asyncInstance)
        case .touchUpCheckAllButton:
            return Observable.concat([
                Observable.just(Mutation.checkAllToggle).observe(on: MainScheduler.asyncInstance),
                loginUseCase.checkUserCurrentLocationAuthorization().map{Mutation.setAuthorization($0)}.observe(on: MainScheduler.asyncInstance)
            ])
        case .signIn:
            if let loginTypeRawValue = UserDefaultsManager.get(forKey: .loginTypeKey) as? String{
                if let loginType = LoginType(rawValue: loginTypeRawValue){
                    switch loginType{
                    case .apple:
                        return Observable.concat([
                            loginUseCase.signWithApple(requestModel: .init(authorizationCode: KeyChain.read(key: .appleLoginAuthorizationCodeKey) ?? "", identityToken: KeyChain.read(key: .appleLoginIdentityTokenKey) ?? "")).map{ Mutation.signed($0, $1)}.observe(on: MainScheduler.asyncInstance),
                            loginUseCase.setUserLocation(userLocationModel: UserLocation(latitude: currentState.currentLocation!.latitude, longitude: currentState.currentLocation!.latitude)).map{ _ in Mutation.successedUploadUserLocation}
                        ])
                    case .kakao:
                        return Observable.concat([
                            loginUseCase.signWithKakao(kakaoAccessToken: KeyChain.read(key: .kakaoLoginAccessTokenKey) ?? "").map{ Mutation.signed($0, $1) }.observe(on: MainScheduler.asyncInstance),
                            loginUseCase.setUserLocation(userLocationModel: UserLocation(latitude: currentState.currentLocation!.latitude, longitude: currentState.currentLocation!.latitude)).map{ _ in Mutation.successedUploadUserLocation}
                        ])
                    }
                }
            }
            return Observable.empty()
        case .checkAuthorization:
            return loginUseCase.checkUserCurrentLocationAuthorization().map{Mutation.setAuthorization($0)}.observe(on: MainScheduler.asyncInstance)
        case .readCurrentLocation:
            loginUseCase.startRunning()
            return loginUseCase.getUserLocation().map{Mutation.setCurrentLocation($0)}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .changeCheckArray(let index):
            newState.checkArray[index].toggle()
        case .checkAllToggle:
            newState.checkAllState.toggle()
            newState.checkArray[0] = newState.checkAllState
            newState.checkArray[1] = newState.checkAllState
        case .signed(let accessToken, let refreshToken):
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
            UserDefaults.standard.setValue(refreshToken, forKey: "refreshToken")
        case .setAuthorization(let status):
            newState.authorization = status
            if newState.authorization == .allowed {
                newState.checkArray[2] = true
            }else{
                newState.checkArray[2] = false
            }
        case .setCurrentLocation(let location):
            newState.currentLocation = location
        case .successedUploadUserLocation:
            loginUseCase.stopRunning()
            newState.successedSignIn = true
        }
        return newState
    }
}
