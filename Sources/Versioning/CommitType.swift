public enum CommitType: String, CaseIterable {
    case fix
    case feature = "feat"
    case build
    case chore
    case ci
    case docs
    case style
    case refactor
    case perf
    case test
}
