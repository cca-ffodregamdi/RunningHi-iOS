//
//  Project.swift
//  Packages
//
//  Created by 유현진 on 6/5/24.
//

import ProjectDescription

let project = Project(
    name: "Coordinator",
    targets: [
        .target(
            name: "Coordinator",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.coordinator",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation")),
                .project(target: "Domain", path: .relativeToRoot("Projects/Domain")),
                .project(target: "Data", path: .relativeToRoot("Projects/Data")),
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
