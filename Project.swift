import ProjectDescription

let project = Project(
    name: "Ppakgongdan",
    settings: .settings(base: ["DEVELOPMENT_TEAM": "L348QC8MG7"]),
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
            entitlements: .dictionary([
                "com.apple.developer.applesignin": ["Default"]
            ]),
            dependencies: [
                .project(target: "Feature", path: "Feature"),
                .project(target: "UI", path: "UI")
            ]
        )
    ]
)
