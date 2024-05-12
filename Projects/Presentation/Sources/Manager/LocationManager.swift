//
//  LocationManager.swift
//  Presentation
//
//  Created by 오영석 on 5/11/24.
//

import CoreLocation

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
        
    typealias FetchLocationCompletion = (CLLocationCoordinate2D?, Error?) -> Void
    private var fetchLocationCompletion: FetchLocationCompletion?
    
    override init() {
        super.init()
        
        self.delegate = self
        self.requestWhenInUseAuthorization()
        self.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func startUpdatingLocation() {
        super.startUpdatingLocation()
    }
    
    override func stopUpdatingLocation() {
        super.stopUpdatingLocation()
    }

    override func requestLocation() {
        super.requestLocation()
    }
    
    func fetchLocation(completion: @escaping FetchLocationCompletion) {
        self.requestLocation()
        self.fetchLocationCompletion = completion
    }
}

extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        
        self.fetchLocationCompletion?(coordinate, nil)
        self.fetchLocationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location (\(error))")
        
        self.fetchLocationCompletion?(nil, error)
        self.fetchLocationCompletion = nil
    }
    
    // 현재 인증 상태 확인
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            print("Location Auth: Allow")
            self.startUpdatingLocation()
        case .notDetermined , .denied , .restricted:
            print("Location Auth: denied")
            self.stopUpdatingLocation()
        default: break
        }
    }
}
