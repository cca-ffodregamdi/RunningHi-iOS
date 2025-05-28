@preconcurrency import ProjectDescription

let project = Project(
    name: "RunningHi",
    targets: [
        .target(
            name: "RunningHi",
            destinations: .iOS,
            product: .app,
            bundleId: "com.runninghi.app",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "러닝하이", // 앱 이름
                    "LSApplicationCategoryType": "public.app-category.health-fitness", // 앱 카테고리
                    "UISupportedInterfaceOrientations": [ // 앱 지원 방향
                            "UIInterfaceOrientationPortrait" // portrait 설정
                    ],
                    "UILaunchStoryboardName": "LaunchScreen.storyboard", // 런치스크린
                    
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
                    "CFBundleIconName" : "AppIcon", // 앱 아이콘
                    "LSApplicationQueriesSchemes": [ // 외부 앱 스킴 허용 설정
                        "kakaokompassauth", // 카카오 인증 관련
                        "kakaolink" // 카카오 링크 관련
                    ],
                    "CFBundleURLTypes": [
                        [
                            "CFBundleTypeRole": "Editor",
                            "CFBundleURLSchemes": [
                                "kakao9416fb784a8d5012e650504a17498e09" // 카카오 로그인용 URL 스킴
                            ]
                        ]
                    ],
                    "CFBundleShortVersionString": "1.0.4", // 앱 버전
                    "CFBundleVersion" : "2", // 빌드 번호
                    "NSAppTransportSecurity" : [ // ATS
                        "NSAllowsArbitraryLoads": true // 모든 도메인에 대해 HTTP 허용
                    ],
                    "NSLocationAlwaysAndWhenInUseUsageDescription": "러닝하이에서 위치 정보 수집을 위해 동의가 필요합니다.",
                    "NSLocationWhenInUseUsageDescription": "러닝하이에서 위치 정보 수집을 위해 동의가 필요합니다.",
                    "NSMotionUsageDescription": "러닝하이에서 정확한 위치 정보 수집을 위해 동의가 필요합니다.",
                    "UIBackgroundModes": [// 백그라운드 작업 설정
                        "location", // 위치 추적
                        "fetch", // 백그라운드 fetch
                        "remote-notification" // 원격 알림
                    ],
                    "ITSAppUsesNonExemptEncryption": false // 미국 수출 규제 관련 암호화 기술 사용 여부
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: "RunningHi.entitlements",
            dependencies: [
                .project(target: "Coordinator", path: .relativeToRoot("Projects/Coordinator")),
            ],
            settings: .settings(base: [
                "TARGETED_DEVICE_FAMILY" : "1"
            ])
        ),
    ]
)
