import ProjectDescription

let project = Project(
    name: "RunningHi",
    targets: [
        .target(
            name: "RunningHi",
            destinations: .iOS,
            product: .app,
            bundleId: "com.runninghi.app",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "CFBundleIconName" : "AppIcon",
                    "LSApplicationQueriesSchemes": [
                        "kakaokompassauth",
                        "kakaolink"
                    ],
                    "CFBundleURLTypes": [
                        [
                            "CFBundleTypeRole": "Editor",
                            "CFBundleURLSchemes": [
                                "kakao9416fb784a8d5012e650504a17498e09"
                            ]
                        ]
                    ],
                    "NSAppTransportSecurity" : [
                        "NSAllowsArbitraryLoads": true
                    ],
                    "NSLocationAlwaysAndWhenInUseUsageDescription": "러닝하이에서 위치 정보 수집을 위해 동의가 필요합니다.",
                    "NSLocationWhenInUseUsageDescription": "러닝하이에서 위치 정보 수집을 위해 동의가 필요합니다.",
                    "NSMotionUsageDescription": "러닝하이에서 정확한 위치 정보 수집을 위해 동의가 필요합니다.",
                    "UIBackgroundModes": ["location", "fetch", "remote-notification"]
                ]
                
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: "RunningHi.entitlements",
            dependencies: [
                .project(target: "Coordinator", path: .relativeToRoot("Projects/Coordinator")),
                .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation")),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKCommon"),
            ]
        ),
    ]
)
