import Foundation

enum CompilerError: Error {
    case compilationFailed(String)
}

struct CompilerImpl: Compiler {

    private let logger: Logger
    private let sdkPath = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
    private let target = "arm64-apple-ios18.0-simulator"
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func compileApp(sources: [String], metadata: Metadata) throws {
        
        let command = CompilerCommand(options: [
            .sourceFiles(sources),
            .target(target),
            .sdkPath(sdkPath),
            .emitExecutable,
            .outputPath(metadata.bundleDir! + "/" + metadata.name)
        ])
        
        logger.log(message: "Executing compilation command: \(command.resultCommand)")
        
        let result = Shell.run(command.resultCommand)
        
        if result.isSuccess {
            logger.log(message: "Compilation successful: \(metadata.name)")
        } else {
            throw CompilerError.compilationFailed(result.error)
        }
    }
}
