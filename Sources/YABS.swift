import Foundation

struct YABS {
    private let compiler: Compiler
    private let logger: Logger
    private let projectParser: ProjectParser
    private let folderManager: FolderManager
    private let plistFactory: PlistFactory
    private let packageParser: PackageParser

    init(
        compiler: Compiler,
        logger: Logger,
        projectParser: ProjectParser,
        folderManager: FolderManager,
        plistFactory: PlistFactory,
        packageParser: PackageParser
    ) {
        self.compiler = compiler
        self.logger = logger
        self.projectParser = projectParser
        self.folderManager = folderManager
        self.plistFactory = plistFactory
        self.packageParser = packageParser
    }

    func build(projectPath: String) throws {
        // 1. Parse project
        let project = try projectParser.parse(projectPath: projectPath)
        
        // 2. Create temp directory
        let tempBuildDirectory = project.path + "/tmp"
        try? folderManager.deleteFolder(at: tempBuildDirectory)
        try folderManager.createFolder(at: tempBuildDirectory)

        // 3. Create .app bundle directory
        let bundleDir = project.path + "/\(project.name).app"
        try? folderManager.deleteFolder(at: bundleDir)
        try folderManager.createFolder(at: bundleDir)

        let packages = try project.localPackages.map { packagePath in
            try packageParser.parse(packagePath: projectPath + "/" + packagePath)
        }

        var dependencies = packages.map { package in
            package.name
        }

        try packages.forEach { package in
            let nestedDependencies = try compilePackageRecursively(
                package: package,
                tempBuildDirectory: tempBuildDirectory
            )
            dependencies.append(contentsOf: nestedDependencies)
        }

        // 4. Compile app binary
        let _ = try compiler.compileApp(
            sources: project.swiftFiles,
            metadata: Metadata(
                name: project.name,
                tempDir: tempBuildDirectory,
                bundleDir: bundleDir,
                staticLibrariesSearchPath: tempBuildDirectory,
                staticLibraries: dependencies
            )
        )

        // 5. Create Info.plist
        try plistFactory.createInfoPlist(
            executableName: project.name,
            bundleIdentifier: "id",
            bundleName: project.name,
            version: "1.0",
            atPath: bundleDir + "/Info.plist"
        )
    }

    func compilePackageRecursively(
        package: SwiftPackage,
        tempBuildDirectory: String
    ) throws -> [String] {
        var dependencyNames: [String] = []
        for dependency in package.dependencies {
            dependencyNames = try compilePackageRecursively(
                package: dependency,
                tempBuildDirectory: tempBuildDirectory
            )
        }

        _ = try compiler.compileLibrary(
            sources: package.sources,
            metadata: Metadata(
                name: package.name,
                tempDir: tempBuildDirectory,
                bundleDir: tempBuildDirectory,
                staticLibrariesSearchPath: tempBuildDirectory,
                staticLibraries: dependencyNames
            )
        )
        return [package.name] + dependencyNames
    }
}

