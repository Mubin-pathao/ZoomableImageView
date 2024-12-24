// swift-tools-version: 5.4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZoomableImageView",
    
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ZoomableImageView",
            targets: ["ZoomableImageView"]),
    ], dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ZoomableImageView",
            dependencies: [
                .product(name: "SDWebImage", package: "SDWebImage")
            ]
        ),
        .testTarget(
            name: "ZoomableImageViewTests",
            dependencies: ["ZoomableImageView"]
        ),
    ]
)
