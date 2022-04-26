// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WordNet",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "WordNet",
            targets: ["WordNet"]),
    ],
    dependencies: [
        .package(name: "MorphologicalAnalysis", url: "https://github.com/StarlangSoftware/TurkishMorphologicalAnalysis-Swift.git", .exact("1.0.4"))],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WordNet",
            dependencies: ["MorphologicalAnalysis"],
            exclude: ["turkish1944_dictionary.txt", "turkish1944_wordnet.xml",
                      "turkish1955_dictionary.txt", "turkish1955_wordnet.xml",
                      "turkish1959_dictionary.txt", "turkish1959_wordnet.xml",
                      "turkish1966_dictionary.txt", "turkish1966_wordnet.xml",
                      "turkish1969_dictionary.txt", "turkish1969_wordnet.xml",
                      "turkish1974_dictionary.txt", "turkish1974_wordnet.xml",
                      "turkish1983_dictionary.txt", "turkish1983_wordnet.xml",
                      "turkish1988_dictionary.txt", "turkish1988_wordnet.xml"],
            resources: [.process("turkish_wordnet.xml"),.process("english_wordnet_version_31.xml"),.process("english_exception.xml")]),
        .testTarget(
            name: "WordNetTests",
            dependencies: ["WordNet"]),
    ]
)
