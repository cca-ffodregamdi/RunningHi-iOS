//
//  Project.swift
//  Config
//
//  Created by 유현진 on 5/1/24.
//

import ProjectDescription

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.presentation",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Domain", path: .relativeToRoot("Projects/Domain")),
                .project(target: "Common", path: .relativeToRoot("Projects/Common")),
                .external(name: "ReactorKit"),
                .external(name: "RxSwift"),
                .external(name: "SnapKit"),
                .external(name: "Kingfisher"),
                .external(name: "RxCocoa"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .external(name: "RxKakaoSDKAuth"),
                .external(name: "RxKakaoSDKUser"),
                .external(name: "KakaoSDKCommon"),
                .external(name: "RxKakaoSDKCommon"),
                .external(name: "RxDataSources"),
            ]
        ),
    ]
)
