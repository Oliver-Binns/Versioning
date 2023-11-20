import ArgumentParser
import Versioning

extension Version: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(string: argument)
    }
}
