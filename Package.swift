// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftPasskeys",
    platforms: [.macOS(.v12)],
	products: [
		.executable(name: "SwiftPasskeyAuthorizer", targets: ["SwiftPasskeyAuthorizer"]),
		.executable(name: "SwiftPasskeyServer", targets: ["SwiftPasskeyServer"]),
	],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events", branch: "main"),
		.package(url: "https://github.com/swift-server/webauthn-swift", revision: "d7c9f9f47f2df93af74e3db6dfd65b722d77c62b"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftPasskeyAuthorizer",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            ],
			plugins: [
//				.plugin(name: "AWSLambdaPackager", package: "swift-aws-lambda-runtime"),
			]),
		.executableTarget(
			name: "SwiftPasskeyServer",
			dependencies: [
				.product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
				.product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
				.product(name: "WebAuthn", package: "webauthn-swift"),
			]),
    ]
)
