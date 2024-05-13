//
//  LocationManager.swift
//  Presentation
//
//  Created by 오영석 on 5/13/24.
//

import Foundation
import UIKit
import CoreLocation

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    override init() {
        super.init()
        self.delegate = self
        self.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
        guard CLLocationManager.locationServicesEnabled() else {
            showRequestLocationServiceAlert()
            return
        }
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = self.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
}

extension LocationManager {
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 한다.
            if (locations.last?.coordinate) != nil {
                // ⭐️ 사용자 위치 정보 사용
            }
            
            // startUpdatingLocation()을 사용하여 사용자 위치를 가져왔다면
            // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
            stopUpdatingLocation()
        }

    // 사용자가 GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했을 때 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
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
        
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        if let windowScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first as? UIWindowScene,
           let rootViewController = windowScene.windows
            .first(where: { $0.isKeyWindow })?.rootViewController {
                rootViewController.present(requestLocationServiceAlert, animated: true)
        }

    }
}

