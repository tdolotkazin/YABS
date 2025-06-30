import Foundation

struct YABS {
    private let compiler: Compiler
    private let logger: Logger
    private let projectParser: ProjectParser
    private let folderManager: FolderManager
    private let plistFactory: PlistFactory

    init(
        compiler: Compiler,
        logger: Logger,
        projectParser: ProjectParser,
        folderManager: FolderManager,
        plistFactory: PlistFactory
    ) {
        self.compiler = compiler
        self.logger = logger
        self.projectParser = projectParser
        self.folderManager = folderManager
        self.plistFactory = plistFactory
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

        // 4. Compile app binary
        let _ = try compiler.compileApp(
            sources: project.swiftFiles,
            metadata: Metadata(
                name: project.name,
                tempDir: tempBuildDirectory,
                bundleDir: bundleDir
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
}

