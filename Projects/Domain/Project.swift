//
//  Project.swift
//  Config
//
//  Created by 유현진 on 5/1/24.
//

import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.domain",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        ),
    ]
)
