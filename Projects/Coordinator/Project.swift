//
//  Project.swift
//  Packages
//
//  Created by 유현진 on 6/5/24.
//

@preconcurrency import ProjectDescription

let project = Project(
    name: "Coordinator",
    targets: [
        .target(
            name: "Coordinator",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.coordinator",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation")),
                .project(target: "Data", path: .relativeToRoot("Projects/Data")),
                .project(target: "Common", path: .relativeToRoot("Projects/Common")),
            ]
        ),
    ]
)
