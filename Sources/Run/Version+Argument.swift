import ArgumentParser
import Versioning

extension Version: @retroactive ExpressibleByArgument {
    public init?(argument: String) {
        self.init(string: argument)
    }
}
