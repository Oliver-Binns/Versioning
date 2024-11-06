import Foundation

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
        
        
        let components = string.split(separator: ": ", maxSplits: 1)
        guard components.count == 2 else {
            throw CommitFormatError.invalid(string)
        }
        
        let conventionalCommitComponent = components[0]
        let isScopeIndicatorPresent = conventionalCommitComponent.contains("(")
        self.isBreakingChange = components[0].last == "!"

        

        if(isScopeIndicatorPresent) {
            if(self.isBreakingChange) {
                let regexPattern = "^[a-zA-Z]+\\([a-zA-Z-]+\\)!$"
                let isValid = conventionalCommitComponent.range(of: regexPattern, options: .regularExpression, range: nil, locale: nil) != nil
                if(!isValid) {
                    throw CommitFormatError.invalid("Invalid scope or commit type1")
                }
            }
            else {
                let regexPattern = "^[a-zA-Z]+\\([a-zA-Z-]+\\)!?$"
                let isValid = conventionalCommitComponent.range(of: regexPattern, options: .regularExpression, range: nil, locale: nil) != nil
                if(!isValid) {
                    throw CommitFormatError.invalid("Invalid scope or commit type2")
                }
            }
        }
        let commitType: Substring
        
        if(isScopeIndicatorPresent) {
            commitType = components[0].split(separator: "(", maxSplits: 1)[0]
        } else {
            if(isBreakingChange) {
                commitType = components[0].split(separator: "!", maxSplits: 1)[0]
            } else {
                commitType = components[0]
            }
        }
        if let type = CommitType(rawValue: String(commitType)) {
            self.type = type
        } else {
            throw CommitFormatError.invalidPrefix(components[0])
        }

        self.message = String(components[1])
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
