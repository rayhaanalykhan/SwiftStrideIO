// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

// This file is part of SwiftStrideIO. For licensing information, see the LICENSE file.

import PackageDescription

let package = Package(
    
    name: "SwiftStrideIO",
    
    platforms: [
        .iOS(.v13)
    ],
    
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftStrideIO",
            targets: ["SwiftStrideIO"]
        ),
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/rayhaanalykhan/CipherEncryption.git", branch: "main")
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftStrideIO",
            dependencies: ["CipherEncryption"] // Add dependency here
        ),
        
        
        
        
        
        
        
//        .testTarget(
//            name: "SwiftStrideIOTests",
//            dependencies: ["SwiftStrideIO"]),
    ]
)
