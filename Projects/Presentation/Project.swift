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
            dependencies: []
        ),
    ]
)
