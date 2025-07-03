import Foundation

protocol PackageParser {
    func parse(packagePath: String) throws -> SwiftPackage
}

struct PackageParserImpl: PackageParser {
    private let logger: Logger = ConsoleLogger()
    private let fileProvider: FileProvider = FileProviderImpl()

    func parse(packagePath: String) throws -> SwiftPackage {
        logger.log(message: "Trying to parse package at path: \(packagePath)")
        let result = Shell.run("swift package dump-package", workingDirectory: packagePath)

        guard result.isSuccess else {
            logger.log(message: "Failed to dump package: \(result.error)")
            throw PackageParserError.dumpError
        }

        do {
            let jsonData = result.output.data(using: .utf8)!
            let packageData = try JSONDecoder().decode(PackageData.self, from: jsonData)
            // Get the root path from packageKind
            let sourcesPath = packageData.packageKind.root.first ?? ""
            let sources = try fileProvider.findFiles(at: sourcesPath, withExtension: "swift").filter { !$0.contains("Package.swift") }

            // Extract dependencies from targets since the top-level dependencies are file system paths
            let targetDependenciesPaths = packageData.targets.flatMap { target in
                target.dependencies.flatMap { dep in
                    dep.byName.compactMap { dependencyName in
                        // Find the first dependency path in dependencies where nameForTargetDependencyResolutionOnly matches dependencyName
                        if let depPath = packageData.dependencies
                            .flatMap({ $0.fileSystem })
                            .first(where: { $0.nameForTargetDependencyResolutionOnly == dependencyName })?.path {
                            return depPath
                        } else {
                            return nil
                        }
                    }
                }
            }

            return SwiftPackage(
                name: packageData.name,
                sources: sources,
                dependencies: try targetDependenciesPaths.map { try parse(packagePath: $0) }
            )
        } catch {
            logger.log(message: "Failed to parse package data: \(error)")
            throw PackageParserError.parseError(message: error.localizedDescription)
        }
    }
}
