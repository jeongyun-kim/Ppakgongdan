//
//  Project.swift
//  Config
//
//  Created by 김정윤 on 10/29/24.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "Common", // 프로젝트 명
    targets: [ // 프로젝트의 타겟
        .target(
            name: "Common",
            destinations: [.iPhone], // 지원 기기 설정
            product: .framework,
            bundleId: "com.jeongyun.common",
            deploymentTargets: .iOS("16.0"), // 지원 최소 버전 설정,
            infoPlist: .extendingDefault(with: [:]),
            sources: ["ReSources/**"]
        )
    ]
)
