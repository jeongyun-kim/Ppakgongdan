//
//  Project.swift
//  Config
//
//  Created by 김정윤 on 11/2/24.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "NetworkKit", // 프로젝트 명
    packages: [ // SPM의 Packages
      
    ],
    targets: [ // 프로젝트의 타겟
        .target(
            name: "NetworkKit",
            destinations: [.iPhone], // 지원 기기 설정
            product: .framework,
            bundleId: "com.jeongyun.network",
            deploymentTargets: .iOS("17.0"), // 지원 최소 버전 설정,
            infoPlist: .extendingDefault(with: ["NSAppTransportSecurity":["NSAllowsArbitraryLoads":true]]),
            sources: ["Sources/**"],
            dependencies: [
               
                .project(target: "Utils", path: "../Utils")
            ]
        )
    ]
)
