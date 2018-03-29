// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PwnedPasswords",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PwnedPasswords",
  targets: ["PwnedPasswords"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Quick/Quick.git", .branch("master")),
      .package(url: "https://github.com/Quick/Nimble.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PwnedPasswords",
  dependencies: [], path: "PwnedPasswords/Classes"),
        .testTarget(
            name: "PwnedPasswordsTests",
      dependencies: ["PwnedPasswords", "Quick", "Nimble"], path: "Example/Tests"),
    ]
)
