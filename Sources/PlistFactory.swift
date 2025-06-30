import Foundation

protocol PlistFactory {
    func createInfoPlist(
        executableName: String,
        bundleIdentifier: String,
        bundleName: String,
        version: String,
        atPath: String
    ) throws
}

struct PlistFactoryImpl: PlistFactory {
    func createInfoPlist(
        executableName: String,
        bundleIdentifier: String,
        bundleName: String,
        version: String,
        atPath: String
    ) throws {
        fatalError("Not implemented: Part 1")
    }
}
