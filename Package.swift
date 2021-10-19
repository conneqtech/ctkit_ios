// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ctkit",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "ctkit",
            targets: ["ctkit"]),
    ],
    dependencies: [
        .package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.2"),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .exact("4.8.2")),
        .package(name: "AppAuth", url: "https://github.com/openid/AppAuth-iOS.git", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "ctkit",
            dependencies: ["RxSwift", "Alamofire", "AppAuth"],
            path: "Source")
    ]
)
