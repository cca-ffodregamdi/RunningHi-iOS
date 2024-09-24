//
//  Project.swift
//  Config
//
//  Created by 유현진 on 5/5/24.
//

@preconcurrency import ProjectDescription

let project = Project(
    name: "Common",
    targets: [
        .target(
            name: "Common",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.common",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Kingfisher"),
                .project(target: "Domain", path: .relativeToRoot("Projects/Domain")),
            ]
        ),
    ]
)
