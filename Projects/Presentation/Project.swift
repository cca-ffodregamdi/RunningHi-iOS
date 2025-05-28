//
//  Project.swift
//  Config
//
//  Created by 유현진 on 5/1/24.
//

@preconcurrency import ProjectDescription

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.presentation",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: .relativeToRoot("Projects/Domain")),
                .project(target: "Common", path: .relativeToRoot("Projects/Common")),
                .external(name: "ReactorKit"),
                .external(name: "SnapKit"),
                .external(name: "RxDataSources"),
                .external(name: "DGCharts"),
            ]
        ),
    ]
)
