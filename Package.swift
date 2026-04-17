// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CommentPrimitive",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "CommentPrimitive", targets: ["CommentPrimitive"]),
    ],
    targets: [
        .target(name: "CommentPrimitive"),
        .testTarget(
            name: "CommentPrimitiveTests",
            dependencies: ["CommentPrimitive"]
        ),
    ]
)
