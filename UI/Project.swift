//
//  Project.swift
//  Config
//
//  Created by 김정윤 on 11/2/24.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "UI", // 프로젝트 명
    targets: [ // 프로젝트의 타겟
        .target(
            name: "UI",
            destinations: [.iPhone], // 지원 기기 설정
            product: .framework,
            bundleId: "com.jeongyun.ui",
            deploymentTargets: .iOS("17.0"), // 지원 최소 버전 설정,
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Utils", path: "../Utils")
            ]
        )
    ]
)
