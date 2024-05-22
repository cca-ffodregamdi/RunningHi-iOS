//
//  RunningCourseReactor.swift
//  Presentation
//
//  Created by 오영석 on 5/11/24.
//

import ReactorKit
import RxSwift
import CoreLocation

final class RunningCourseReactor: Reactor {
    
    enum Action {
        case startRunningCourse
        case stopRunningCourse
        case moveToCurrentLocation
        case initializeLocation
    }
    
    enum Mutation {
        case setCoordinates([CLLocationCoordinate2D])
        case setRunning(Bool)
        case setCurrentLocation(CLLocationCoordinate2D)
        case moveToCurrentLocation(CLLocationCoordinate2D)
        case setStartLocation(CLLocationCoordinate2D)
    }
    
    struct State {
        var coordinates: [CLLocationCoordinate2D] = []
        var isRunning: Bool = false
        var currentLocation: CLLocationCoordinate2D?
        var moveToLocation: CLLocationCoordinate2D?
        var startLocation: CLLocationCoordinate2D?
    }
    
    let initialState = State()
    private let locationManager = LocationManager.shared
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startRunningCourse:
            return startRunningCourse()
        case .stopRunningCourse:
            locationManager.stopLocationUpdates()
            return Observable.just(Mutation.setRunning(false))
        case .moveToCurrentLocation:
            guard let currentLocation = locationManager.location?.coordinate else {
                return Observable.empty()
            }
            return Observable.just(Mutation.moveToCurrentLocation(currentLocation))
        case .initializeLocation:
            return initializeLocation()
        }
    }
    
    private func initializeLocation() -> Observable<Mutation> {
        return locationManager.rx.didUpdateLocations
            .map { $0.last?.coordinate }
            .compactMap { $0 }
            .take(1)
            .map { Mutation.setCurrentLocation($0) }
    }
    
    private func startRunningCourse() -> Observable<Mutation> {
        locationManager.startLocationUpdates()
        
        let locationObservable = locationManager.rx.didUpdateLocations
            .map { $0.last?.coordinate }
            .compactMap { $0 }
            .map { [currentState = self.currentState] newCoordinate in
                var updatedCoordinates = currentState.coordinates
                updatedCoordinates.append(newCoordinate)
                return Mutation.setCoordinates(updatedCoordinates)
            }
        
        let startLocationObservable = locationManager.rx.didUpdateLocations
            .map { $0.last?.coordinate }
            .compactMap { $0 }
            .take(1)
            .map { coordinate in Mutation.setStartLocation(coordinate) }
        
        return Observable.merge(
            Observable.just(Mutation.setRunning(true)),
            locationObservable,
            startLocationObservable
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCoordinates(let coordinates):
            newState.coordinates = coordinates
        case .setRunning(let isRunning):
            newState.isRunning = isRunning
        case .setCurrentLocation(let location):
            newState.currentLocation = location
        case .moveToCurrentLocation(let location):
            newState.moveToLocation = location
        case .setStartLocation(let location):
            newState.startLocation = location
        }
        return newState
    }
}

extension CLLocationCoordinate2D {
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let toLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fromLocation.distance(from: toLocation)
    }
}
