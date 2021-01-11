// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LazyPages",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(
      name: "LazyPages",
      targets: ["LazyPages"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "LazyPages",
      dependencies: []
    )
  ]
)
