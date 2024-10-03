//
//  Project.swift
//  Config
//
//  Created by 유현진 on 5/1/24.
//

@preconcurrency import ProjectDescription

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.RunningHi.data",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Domain", path: .relativeToRoot("Projects/Domain")),
                .external(name: "Moya"),
                .external(name: "RxMoya"),
            ]
        ),
        .target(
            name: "RepositoryTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.RunningHi.repositoryTests",
            infoPlist: .default,
            sources: ["RepositoryTests/**"],
            dependencies: [
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
                .external(name: "RxTest"),
                .external(name: "Quick"),
                .external(name: "Nimble"),
            ]
        )
    ]
)
