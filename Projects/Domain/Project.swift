//
//  Project.swift
//  Config
//
//  Created by 유현진 on 5/1/24.
//

@preconcurrency import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.domain",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .external(name: "RxKakaoSDKAuth"),
                .external(name: "RxKakaoSDKUser"),
                .external(name: "KakaoSDKCommon"),
                .external(name: "RxKakaoSDKCommon"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
            ]
        ),
    ]
)
