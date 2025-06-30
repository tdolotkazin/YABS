protocol Compiler {
    func compileApp(sources: [String], metadata: Metadata) throws
}

struct Metadata {
    let name: String
    let tempDir: String
    let bundleDir: String?
}
