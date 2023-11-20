import ArgumentParser

@main
struct Run: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Version enforcer",
        subcommands: [Validate.self, Increment.self],
        defaultSubcommand: Validate.self
    )
}
