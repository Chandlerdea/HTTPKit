//
//  Package.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "HTTPKit",
    products: [
        .library(name: "HTTPKit", targets: ["HTTPKit"])
    ],
    targets: [
        .target(
            name: "HTTPKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "HTTPKitTests",
            dependencies: ["HTTPKit"]
        ),
    ]
)
