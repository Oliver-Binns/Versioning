import Foundation

enum ValidationError: Error {
    case breakingChangeNotFlagged
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        """
        Breaking change detected but commit was not marked as breaking.
        see docs: https://www.conventionalcommits.org/en/v1.0.0/#specification
        """
    }
}
