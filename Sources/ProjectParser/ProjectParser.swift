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
        fatalError("Not implemented: Part 1")
    }
}
