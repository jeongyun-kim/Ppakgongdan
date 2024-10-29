//
//  Project.swift
//  CommonManifests
//
//  Created by 김정윤 on 10/29/24.
//

import Foundation
import ProjectDescription

let project = Project(
    name: "NetworkKit", // 프로젝트 명
    packages: [ // SPM의 Packages
        .remote(url: "https://github.com/Alamofire/Alamofire.git",
                requirement: .upToNextMajor(from: "5.10.0")
        ),
        .remote(url: "https://github.com/Moya/Moya.git",
                requirement: .upToNextMajor(from: "15.0.0"))
    ],
    targets: [ // 프로젝트의 타겟
        .target(
            name: "NetworkKit",
            destinations: [.iPhone], // 지원 기기 설정
            product: .framework,
            bundleId: "com.jeongyun.network",
            deploymentTargets: .iOS("16.0"), // 지원 최소 버전 설정,
            infoPlist: .extendingDefault(with: ["NSAppTransportSecurity":["NSAllowsArbitraryLoads":true]]),
            sources: ["Sources/**"],
            dependencies: [
                .package(product: "Alamofire"),
                .package(product: "Moya")
            ]
        )
    ]
)
