import Foundation

protocol ProjectParser {
    func parse(projectPath: String) throws -> Project
}

struct ProjectParserImpl: ProjectParser {
    private let logger: Logger
    private let fileProvider: FileProvider

    init(logger: Logger, fileProvider: FileProvider) {
        self.logger = logger
        self.fileProvider = fileProvider
    }

    func parse(projectPath: String) throws -> Project {
        let data = try Data(contentsOf: URL(filePath: projectPath + "/project.json"))
        let projectDto = try JSONDecoder().decode(ProjectDto.self, from: data)
        let swiftFiles = try fileProvider.findFiles(at: projectPath + "/" + projectDto.sourcesFolder, withExtension: "swift")
        return Project(
            name: projectDto.name,
            path: projectPath,
            swiftFiles: swiftFiles,
            localPackages: projectDto.localPackages
        )
    }
}
