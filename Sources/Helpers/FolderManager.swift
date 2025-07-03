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
        try fileManager.createDirectory(atPath: path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }
    
    func deleteFolder(at path: String) throws {
        try fileManager.removeItem(atPath: path)
    }
}
