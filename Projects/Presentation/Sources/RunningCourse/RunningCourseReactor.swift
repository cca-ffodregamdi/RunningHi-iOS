//
//  RunningCourseReactor.swift
//  Presentation
//
//  Created by 오영석 on 5/11/24.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import CoreLocation

final class RunningCourseReactor: Reactor {
    
    enum Action {
        case startRunningCourse
        case stopRunningCourse
    }
    
    enum Mutation {
        case setCoordinates([CLLocationCoordinate2D])
        case setRunning(Bool)
    }
    
    struct State {
        var coordinates: [CLLocationCoordinate2D] = []
        var isRunning: Bool = false
    }
    
    let initialState = State()
    private let locationManager = LocationManager.shared
    private let timer = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startRunningCourse:
            return startRunningCourse()
        case .stopRunningCourse:
            locationManager.stopLocationUpdates()
            return Observable.just(Mutation.setRunning(false))
        }
    }
    
    private func startRunningCourse() -> Observable<Mutation> {
        locationManager.startLocationUpdates()
        let timerObservable = timer
            .withLatestFrom(locationManager.rx.didUpdateLocations)
            .map { $0.map { $0.coordinate } }
            .distinctUntilChanged()
            .map(Mutation.setCoordinates)
        
        return Observable.merge(
            Observable.just(Mutation.setRunning(true)),
            timerObservable
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCoordinates(let coordinates):
            newState.coordinates.append(contentsOf: coordinates)
        case .setRunning(let isRunning):
            newState.isRunning = isRunning
        }
        return newState
    }
}
