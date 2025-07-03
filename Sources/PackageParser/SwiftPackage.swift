struct SwiftPackage {
    let name: String
    let sources: [String]
    let dependencies: [SwiftPackage]
}

struct PackageData: Codable {
    let name: String
    let packageKind: PackageKind
    let dependencies: [Dependency]
    let targets: [Target]

    struct PackageKind: Codable {
        let root: [String]
    }

    struct Dependency: Codable {
        let fileSystem: [FileSystemDependency]

        struct FileSystemDependency: Codable {
            let identity: String
            let nameForTargetDependencyResolutionOnly: String
            let path: String
        }
    }

    struct Target: Codable {
        let dependencies: [TargetDependency]

        struct TargetDependency: Codable {
            let byName: [String?]
        }
    }
}

enum PackageParserError: Error {
    case dumpError
    case parseError(message: String)
}
