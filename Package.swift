import PackageDescription

let package = Package(
  name: "FileManager",
  targets: [
    Target(name: "UnitTests", dependencies: [.Target(name: "FileManager")]),
    Target(name: "FileManager")
  ],
  dependencies: [
  .Package(url: "https://github.com/alloyapple/swiftwrappingc.git", majorVersion: 0)
  //.Package(url: "https://git.oschina.net/GoldTeam/swiftwrappingc.git", majorVersion: 1, minor: 0)
  //  .Package(url: "../swiftdev/swiftc/", majorVersion: 0, minor: 2)
  ]
)
