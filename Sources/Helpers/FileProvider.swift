import Foundation

protocol FileProvider {
    func findFiles(at path: String, withExtension extension: String) throws -> [String]
}

struct FileProviderImpl: FileProvider {
    private let fileManager = FileManager.default

    func findFiles(at path: String, withExtension extension: String) throws -> [String] {
        var matchingFiles: [String] = []

        guard let enumerator = fileManager.enumerator(atPath: path) else {
            throw NSError(domain: "FileProviderError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create directory enumerator for path: \(path)"])
        }

        for case let fileName as String in enumerator {
            if fileName.hasSuffix(".\(`extension`)") {
                let fullPath = (path as NSString).appendingPathComponent(fileName)
                matchingFiles.append(fullPath)
            }
        }

        return matchingFiles
    }
}
