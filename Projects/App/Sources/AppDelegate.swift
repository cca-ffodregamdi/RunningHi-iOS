//
//  AppDelegate.swift
//  RunningHi
//
//  Created by 유현진 on 5/1/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKUser
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init() {
        super.init()
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        KakaoSDK.initSDK(appKey: "9416fb784a8d5012e650504a17498e09")
        if let options = launchOptions{
            if let remoteNotification = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]{
                // 푸시에서 받은 내용
            }
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkNotificationSetting),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        return true
    }
    
    @objc private func checkNotificationSetting(){
            UNUserNotificationCenter.current().getNotificationSettings { permission in
                switch permission.authorizationStatus{
                case .authorized:
                    print("푸시 알림 동의")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                case .denied:
                    print("푸시 알림 거부")
                    DispatchQueue.main.async {
                        UIApplication.shared.unregisterForRemoteNotifications()
                    }
                case .notDetermined:
//                    print("푸시 알림 한번만 동의")
                    break
                case .provisional:
//                    print("푸시 수신 임시 중단")
                    break
                case .ephemeral:
//                    print("푸시 설정이 App Clip에서만 동의한 경우")
                    break
                @unknown default:
//                    print("unknown status")
                    break
                }
        }
    }
}

extension AppDelegate: MessagingDelegate{
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate{
    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
    }
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .badge, .sound])
    }
}
