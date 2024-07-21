//
//  RxCLLocationManagerDelegateProxy.swift
//  Presentation
//
//  Created by 오영석 on 5/20/24.
//

//import RxSwift
//import RxCocoa
//import CoreLocation
//
//class RxCLLocationManagerDelegateProxy: DelegateProxy<LocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
//    
//    public init(locationManager: LocationManager) {
//        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
//    }
//    
//    public static func registerKnownImplementations() {
//        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
//    }
//    
//    public static func currentDelegate(for object: LocationManager) -> CLLocationManagerDelegate? {
//        return object.delegate
//    }
//    
//    public static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: LocationManager) {
//        object.delegate = delegate
//    }
//}
//
//extension Reactive where Base: LocationManager {
//    var delegate: DelegateProxy<LocationManager, CLLocationManagerDelegate> {
//        return RxCLLocationManagerDelegateProxy.proxy(for: base)
//    }
//    
//    var didUpdateLocations: Observable<[CLLocation]> {
//        return delegate
//            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
//            .map { parameters in
//                return parameters[1] as? [CLLocation] ?? []
//            }
//    }
//    
//    var didFailWithError: Observable<Error> {
//        return delegate
//            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:)))
//            .map { parameters in
//                return parameters[1] as? Error ?? NSError(domain: "Unknown error", code: -1, userInfo: nil)
//            }
//    }
//}
