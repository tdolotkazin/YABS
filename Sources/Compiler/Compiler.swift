protocol Compiler {
    func compileApp(sources: [String], metadata: Metadata) throws
    func compileLibrary(sources: [String], metadata: Metadata) throws
}

struct Metadata {
    let name: String
    let tempDir: String
    let bundleDir: String?
    let staticLibrariesSearchPath: String
    let staticLibraries: [String]
}
