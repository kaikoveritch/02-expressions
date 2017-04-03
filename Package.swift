import PackageDescription

let package = Package(
    name: "02-expressions",
    dependencies: [
        .Package(url: "https://github.com/kyouko-taiga/LogicKit",
                 majorVersion: 0),
    ]
)
