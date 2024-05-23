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
}

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    static let shared = LocationManager()
    static var routeInfo = (latitude: Double(), longitude: Double(), timestamp: Date())
    var locations = [CLLocation]()
    
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
                
//                print("현재 사용자의 authorization status: \(authorization)")
                self.checkUserCurrentLocationAuthorization(authorization)
            } else {
//                print("위치 권한 허용 꺼져있음")
                self.showRequestLocationServiceAlert()
            }
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
//            print("NotDetermined")
            self.desiredAccuracy = kCLLocationAccuracyBest
            self.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
//            print("Denied, 아이폰 설정으로 유도")
            self.showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
//            print("Authorized")
            self.startUpdatingLocation()
            
        default:
            break
//            print("Default")
        }
    }
}

extension LocationManager {
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            LocationManager.routeInfo.latitude = lastLocation.coordinate.latitude
            LocationManager.routeInfo.longitude = lastLocation.coordinate.longitude
            LocationManager.routeInfo.timestamp = Date()
            self.locations.append(lastLocation)
        }
        stopUpdatingLocation()
    }
    
    // 사용자가 GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했을 때 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown: 
                break
//                print("Temporary location error: \(error.localizedDescription)")
            default:
                break
//                print("Location Manager failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
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
