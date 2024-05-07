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
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation")),
                .external(name: "Kingfisher"),
                
            ]
        ),
    ]
)
