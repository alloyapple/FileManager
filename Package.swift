import PackageDescription

let package = Package(
  name: "FileManager",
  targets: [
    Target(name: "UnitTests", dependencies: [.Target(name: "FileManager")]),
    Target(name: "FileManager")
  ]
)
