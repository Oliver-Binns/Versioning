import ArgumentParser

@main
struct Run: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Word counter.",
        subcommands: [Validate.self, Increment.self],
        defaultSubcommand: Validate.self
    )
}
