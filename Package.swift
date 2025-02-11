// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CmdTool",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .plugin(
            name: "CmdToolPlugin",
            targets: ["CmdToolPlugin"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        )
    ],
    targets: [
        .plugin(
            name: "CmdToolPlugin",
            capability: .command(
                intent: .custom(
                    verb: "CmdToolPlugin",
                    description: "A Plugin CMD tool example."
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "Update SMP project config.")
                ]
            )
        )
    ]
)
