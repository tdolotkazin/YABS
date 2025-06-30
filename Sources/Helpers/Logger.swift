import Foundation

protocol Logger {
    func log(message: String)
}

class ConsoleLogger: Logger {
    func log(message: String) {
        print(message)
    }
}
