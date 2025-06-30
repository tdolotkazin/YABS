import ArgumentParser

@main
struct Build: ParsableCommand {

    @Option(help: "Path to project folder")
    var projectPath: String

    mutating func run() throws {
        let logger = ConsoleLogger()
        let compiler = CompilerImpl(logger: logger)
        let fileProvider = FileProviderImpl()
        let projectParser = ProjectParserImpl(logger: logger, fileProvider: fileProvider)
        let yabs = YABS(
            compiler: compiler,
            logger: logger,
            projectParser: projectParser,
            folderManager: FolderManagerImpl(),
            plistFactory: PlistFactoryImpl()
        )

        try yabs.build(projectPath: projectPath)
    }
}
