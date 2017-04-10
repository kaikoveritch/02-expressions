import PackageDescription

let package = Package(
    name: "expressions",
    dependencies: [
        .Package(url: "https://github.com/kyouko-taiga/LogicKit",
                 majorVersion: 0),
    ]
)
