//
//  AppDelegate.swift
//  RunningHi
//
//  Created by 유현진 on 5/1/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        KakaoSDK.initSDK(appKey: "9416fb784a8d5012e650504a17498e09")
//        UserApi.shared.unlink {(error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("unlink() success.")
//            }
//        }
        return true
    }
}
