import ProjectDescription

let project = Project(
    name: "RunningHi",
    targets: [
        .target(
            name: "RunningHi",
            destinations: .iOS,
            product: .app,
            bundleId: "com.RunningHi",
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
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Coordinator", path: .relativeToRoot("Projects/Coordinator")),
                .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation")),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKCommon"),
            ]
        ),
    ]
)
