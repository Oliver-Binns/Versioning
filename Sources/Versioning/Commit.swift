public struct Commit {
    public let type: CommitType
    public let isBreakingChange: Bool
    public let message: String
    
    init(type: CommitType,
         isBreakingChange: Bool,
         message: String) {
        self.type = type
        self.isBreakingChange = isBreakingChange
        self.message = message
    }
    
    public init(string: String) throws {
        let components = string.split(separator: ": ")
        guard components.count == 2 else {
            throw CommitFormatError.invalid
        }
    
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
        
        message = String(components[1])
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
        case .fix, .refactor, .style:
            return .patch
        default:
            return nil
        }
    }
}
