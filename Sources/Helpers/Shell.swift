import Foundation

class Shell {

    struct CommandResult {
        let output: String
        let error: String
        let exitCode: Int32
        
        var isSuccess: Bool {
            return exitCode == 0
        }
    }

    @discardableResult
    static func run(_ command: String, arguments: [String] = [], workingDirectory: String? = nil) -> CommandResult {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", "\(command) \(arguments.joined(separator: " "))"]
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        if let workingDir = workingDirectory {
            process.currentDirectoryURL = URL(fileURLWithPath: workingDir)
        }
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let error = String(data: errorData, encoding: .utf8) ?? ""
            
            return CommandResult(
                output: output.trimmingCharacters(in: .whitespacesAndNewlines),
                error: error.trimmingCharacters(in: .whitespacesAndNewlines),
                exitCode: process.terminationStatus
            )
        } catch {
            return CommandResult(
                output: "",
                error: "Failed to execute command: \(error.localizedDescription)",
                exitCode: -1
            )
        }
    }
}
