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
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.1")),
        .package(name: "AppAuth", url: "https://github.com/openid/AppAuth-iOS.git", from: "1.4.0"),
        .package(name: "Quick", url: "https://github.com/Quick/Quick.git", from: "2.2.0"),
        .package(name: "Mockingjay", url: "https://github.com/FocusriteGroup/Mockingjay.git", .branch("master")),
        .package(name: "Nimble", url: "https://github.com/Quick/Nimble.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "ctkit",
            dependencies: ["RxSwift", "Alamofire", "AppAuth"],
            path: "Source"),
        .testTarget(
          name: "ctkit_ios-Package",
          dependencies: ["ctkit", "Mockingjay", "RxSwift", "AppAuth", "Quick", "Nimble", .product(name: "RxBlocking", package: "RxSwift")],
          path: "Tests/ctkit_iosTests")
    ]
)
