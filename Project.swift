import ProjectDescription

let project = Project(
    name: "Ppakgongdan",
    targets: [
        .target(
            name: "Ppakgongdan",
            destinations: [.iPhone], // 지원 기기 설정
            product: .app,
            bundleId: "com.jeongyun.Ppakgongdan",
            deploymentTargets: .iOS("17.0"), // 지원 최소 버전 설정
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "NSAppTransportSecurity":["NSAllowsArbitraryLoads":true],
                    // 세로모드 고정
                    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
                ]
            ),
            sources: ["Ppakgongdan/Sources/**"],
            resources: ["Ppakgongdan/Resources/**"],
            dependencies: [
                .project(target: "Feature", path: "Feature")
            ]
        )
    ]
)
