//
//  Project.swift
//  Config
//
//  Created by 김정윤 on 12/9/24.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "Feature-DM", // 프로젝트 명
    targets: [ // 프로젝트의 타겟
        .target(
            name: "Feature-DM",
            destinations: [.iPhone], // 지원 기기 설정
            product: .framework,
            bundleId: "com.jeongyun.feature.dm",
            deploymentTargets: .iOS("17.0"), // 지원 최소 버전 설정,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "NetworkKit", path: "../Network")
            ]
        )
    ]
)
