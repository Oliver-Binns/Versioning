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


        /*let components = string.split(separator: ": ", maxSplits: 1)
        guard components.count == 2 else {
            throw CommitFormatError.invalid(string)
        }

        self.scope = nil
        self.isBreakingChange = components[0].last == "!"
        
        if isBreakingChange {
            let messageLength = components[0].count
            let trimmedExclamation = components[0].prefix(messageLength-1)
            self.type = CommitType(rawValue: String(trimmedExclamation))!
        } else if let type = CommitType(rawValue: String(components[0])) {
            self.type = type
        } else {
            throw CommitFormatError.invalidPrefix(components[0])
        }
        
        message = String(components[1])*/
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
