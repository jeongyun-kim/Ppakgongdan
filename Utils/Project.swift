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
                requirement: .upToNextMajor(from: "1.15.0")),
        .remote(url: "https://github.com/kakao/kakao-ios-sdk.git",
                requirement: .upToNextMajor(from: "2.23.0")),
        .remote(url: "https://github.com/Alamofire/Alamofire.git",
                requirement: .upToNextMajor(from: "5.10.1")),
        .remote(url: "https://github.com/Moya/Moya.git",
                requirement: .upToNextMajor(from: "15.0.0")),
        .remote(url: "https://github.com/socketio/socket.io-client-swift.git",
                requirement: .upToNextMajor(from: "16.1.1")),
        .remote(url: "https://github.com/onevcat/Kingfisher.git",
                requirement: .upToNextMinor(from: "8.1.1")),
        .remote(url: "https://github.com/realm/realm-swift.git",
                requirement: .exact("10.49.2"))
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
                .package(product: "Alamofire"),
                .package(product: "Moya"),
                .package(product: "ComposableArchitecture"),
                .package(product: "KakaoSDK"),
                .package(product: "SocketIO"),
                .package(product: "Kingfisher"),
                .package(product: "RealmSwift")
            ]
        )
    ]
)
