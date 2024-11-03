//
//  Project.swift
//  Config
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "Feature-Home", // 프로젝트 명
    targets: [ // 프로젝트의 타겟
        .target(
            name: "Feature-Home",
            destinations: [.iPhone], // 지원 기기 설정
            product: .framework,
            bundleId: "com.jeongyun.feature.home",
            deploymentTargets: .iOS("17.0"), // 지원 최소 버전 설정,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "NetworkKit", path: "../Network")
            ]
        )
    ]
)
