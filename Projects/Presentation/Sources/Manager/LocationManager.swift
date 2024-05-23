//
//  LocationManager.swift
//  Presentation
//
//  Created by 오영석 on 5/13/24.
//

import Foundation
import UIKit
import CoreLocation

struct RouteInfo: Codable {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    static let shared = LocationManager()
    static var routeInfo = RouteInfo(latitude: 0.0, longitude: 0.0, timestamp: Date())
    var routeInfos = [RouteInfo]()
    
    override init() {
        super.init()
        self.delegate = self
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func startLocationUpdates() {
        self.startUpdatingLocation()
    }

    func stopLocationUpdates() {
        self.stopUpdatingLocation()
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                self.checkUserCurrentLocationAuthorization(authorization)
            } else {
                self.showRequestLocationServiceAlert()
            }
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.desiredAccuracy = kCLLocationAccuracyBest
            self.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            self.showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            self.startUpdatingLocation()
            
        default:
            break
        }
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let timestamp = Date()
            LocationManager.routeInfo = RouteInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude, timestamp: timestamp)
            self.routeInfos.append(RouteInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude, timestamp: timestamp))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                break
            default:
                break
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 - 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .first as? UIWindowScene,
               let rootViewController = windowScene.windows
                .first(where: { $0.isKeyWindow })?.rootViewController {
                    rootViewController.present(requestLocationServiceAlert, animated: true)
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let toLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fromLocation.distance(from: toLocation)
    }
}
