//
//  LocationManager.swift
//  Presentation
//
//  Created by 오영석 on 5/13/24.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import MapKit

public struct RouteInfo: Codable, Equatable {
    public var latitude: Double
    public var longitude: Double
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var timestamp: Date
}

public final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    public static var routeInfo = RouteInfo(latitude: 0.0, longitude: 0.0, timestamp: Date())
    public var previousCoordinate: CLLocationCoordinate2D?
    public var routeInfos = [RouteInfo]()
    
    public let didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    
    override public init() {
        super.init()
        self.delegate = self
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.allowsBackgroundLocationUpdates = true
        self.pausesLocationUpdatesAutomatically = false
    }
    
    public func startLocationUpdates() {
        self.startUpdatingLocation()
    }

    public func stopLocationUpdates() {
        self.stopUpdatingLocation()
    }
    
    public func checkUserDeviceLocationServiceAuthorization() {
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
    
    public func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
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
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            guard let location = locations.last else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
                    
            if let previousCoordinate = self.previousCoordinate {
                var points: [CLLocationCoordinate2D] = []
                let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
                let point2 = CLLocationCoordinate2DMake(latitude, longitude)
                points.append(point1)
                points.append(point2)
                let lineDraw = MKPolyline(coordinates: points, count: points.count)
                NotificationCenter.default.post(name: .didUpdateLocations, object: lineDraw)
            }
            
            self.previousCoordinate = location.coordinate
            
            let timestamp = Date()
            let newRouteInfo = RouteInfo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: timestamp)
            
            LocationManager.routeInfo = newRouteInfo
            self.routeInfos.append(newRouteInfo)
            didUpdateLocationsSubject.onNext(locations)
        }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                break
            default:
                break
            }
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    public func showRequestLocationServiceAlert() {
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
    
    public func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let toLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fromLocation.distance(from: toLocation)
    }
}

extension Notification.Name {
    public static let didUpdateLocations = Notification.Name("didUpdateLocations")
}
