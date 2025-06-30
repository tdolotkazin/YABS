struct CompilerCommand {
    private var options: [CompilerOption]

    init(options: [CompilerOption]) {
        self.options = options
    }

    var resultCommand: String {
        return "swiftc " + options.map { $0.shellString }.joined(separator: " ")
    }
}

enum CompilerOption {
    case sourceFiles([String])
    case target(String)
    case sdkPath(String)
    case emitExecutable
    case librariesSearchPath(String)
    case importsSearchPath(String)
    case linkLibraries([String])
    case outputPath(String)
    case emitStaticLibrary
    case emitModule(String)
    case emitModulePath(String)

    var shellString: String {
        switch self {
        case .sourceFiles(let files):
            files.joined(separator: " ")
        case .target(let target):
            "-target \(target)"
        case .sdkPath(let path):
            "-sdk \(path)"
        case .emitExecutable:
            "-emit-executable"
        case .librariesSearchPath(let path):
            "-L \(path)"
        case .importsSearchPath(let path):
            "-I \(path)"
        case .linkLibraries(let libraries):
            libraries.map({ library in
                "-l \(library)"
            }).joined(separator: " ")
        case .outputPath(let path):
            "-o \(path)"
        case .emitStaticLibrary:
            "-emit-library -static"
        case .emitModule(let name):
            "-emit-module -module-name \(name)"
        case .emitModulePath(let path):
            "-emit-module-path \(path)"
        }
    }
}
