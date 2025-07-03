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
        let data = try PropertyListEncoder().encode(InfoPlist(
            CFBundleExecutable: executableName,
            CFBundleIdentifier: bundleIdentifier,
            CFBundleName: bundleName,
            CFBundleShortVersionString: version,
            CFBundleVersion: version
        )
        )
        try data.write(to: URL(filePath: atPath))
    }
}

struct InfoPlist: Encodable {
    let CFBundleExecutable: String
    let CFBundleIdentifier: String
    let CFBundleName: String
    let CFBundleShortVersionString: String
    let CFBundleVersion: String
}
