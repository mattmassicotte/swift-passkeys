// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftPasskeys",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftPasskeys",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            ],
			plugins: [
//				.plugin(name: "AWSLambdaPackager", package: "swift-aws-lambda-runtime"),
			]),
        .testTarget(
            name: "SwiftPasskeysTests",
            dependencies: ["SwiftPasskeys"]),
    ]
)
