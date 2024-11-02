//
//  Project.swift
//  CommonManifests
//
//  Created by 김정윤 on 11/2/24.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "Utils", // 프로젝트 명
    packages: [
        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git",
                requirement: .upToNextMajor(from: "1.15.0"))
    ],
    targets: [ // 프로젝트의 타겟
        .target(
            name: "Utils",
            destinations: [.iPhone], // 지원 기기 설정
            product: .framework,
            bundleId: "com.jeongyun.utils",
            deploymentTargets: .iOS("17.0"), // 지원 최소 버전 설정,
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Sources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture")
            ]
        )
    ]
)
