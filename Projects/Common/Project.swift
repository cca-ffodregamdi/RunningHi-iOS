//
//  Project.swift
//  Config
//
//  Created by 유현진 on 5/5/24.
//

import ProjectDescription

let project = Project(
    name: "Common",
    targets: [
        .target(
            name: "Common",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.common",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Kingfisher"),
            ]
        ),
    ]
)
