struct Project {
    let name: String
    let path: String
    let swiftFiles: [String]
    let localPackages: [String]
}

struct ProjectDto: Decodable {
    let name: String
    let sourcesFolder: String
    let localPackages: [String]
}
