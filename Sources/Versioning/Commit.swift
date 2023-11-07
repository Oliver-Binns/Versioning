public struct Commit {
    public let type: CommitType
    public let scope: String?
    public let isBreakingChange: Bool
    public let message: String

    init(type: CommitType,
         scope: String? = nil,
         isBreakingChange: Bool,
         message: String) {
        self.type = type
        self.scope = scope
        self.isBreakingChange = isBreakingChange
        self.message = message
    }

    public init(string: String) throws {
        let search = /(?<type>[a-z]+)(\((?<scope>[a-z]+)\))?(?<breaking>!)?: (?<message>(.|\n)+)/

        do {
            guard let match = try search.wholeMatch(in: string) else {
                throw CommitFormatError.invalid(string)
            }

            guard let type = CommitType(rawValue: String(match.output.type)) else {
                throw CommitFormatError.invalidPrefix(match.output.type)
            }
            self.type = type
            self.scope = match.output.scope.map(String.init)
            self.isBreakingChange = match.output.breaking != nil
            self.message = String(match.output.message)
        }
    }
}

extension Commit {
    public var versionIncrement: VersionIncrement? {
        guard !isBreakingChange else {
            return .major
        }

        switch type {
        case .feature:
            return .minor
        case .fix, .refactor, .style, .build:
            return .patch
        default:
            return nil
        }
    }
}
