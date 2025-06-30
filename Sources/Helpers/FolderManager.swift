import Foundation

protocol FolderManager {
    func createFolder(at path: String) throws
    func deleteFolder(at path: String) throws
}

struct FolderManagerImpl: FolderManager {

    private let fileManager: FileManager

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func createFolder(at path: String) throws {
        fatalError("Not implemented: Part 1")
    }
    
    func deleteFolder(at path: String) throws {
        fatalError("Not implemented: Part 1")
    }
}
