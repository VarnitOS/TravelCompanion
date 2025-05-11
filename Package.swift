// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "TravelCompanion",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TravelCompanion",
            targets: ["TravelCompanion"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase-community/supabase-swift.git", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "TravelCompanion",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
            ]),
        .testTarget(
            name: "TravelCompanionTests",
            dependencies: ["TravelCompanion"]),
    ]
) 