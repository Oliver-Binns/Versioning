@testable import Run
import Testing

struct ValidateTests {
    @Test("Allow breaking change when commit message contains `!`")
    func allowsBreakingChangeIfFlagged() throws {
        do {
            var validate = try Validate.parse([
                "--message", "test!: added unit test",
                "--contains-breaking-change", "true"
            ])
            try validate.run()
        } catch ValidationError.breakingChangeNotFlagged {
            Issue.record(
                ValidationError.breakingChangeNotFlagged,
                "Did not expect an error to be thrown as conventional commit allows breaking change"
            )
        }
    }

    @Test("Throws error for breaking change if commit message does not contain `!`")
    func enforcesBreakingChange() throws {
        do {
            var validate = try Validate.parse([
                "--message", "test: added unit test",
                "--contains-breaking-change", "true"
            ])
            try validate.run()

            Issue.record("Expected a `breakingChangeNotFlagged` error to be thrown")
        } catch ValidationError.breakingChangeNotFlagged {
            
        }
    }

    @Test("Does not throw error for non-breaking change if commit message does not contain `!`")
    func allowsNonBreakingChange() throws {
        do {
            var validate = try Validate.parse([
                "--message", "test: added unit test",
                "--contains-breaking-change", "false"
            ])
            try validate.run()
        } catch ValidationError.breakingChangeNotFlagged {
            Issue.record(
                ValidationError.breakingChangeNotFlagged,
                "Did not expect an error to be thrown as there is no breaking change"
            )
        }
    }
}
