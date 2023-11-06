# Versioning

A Swift Package for enforcing Conventional Commits and managing versions.

## Usage

### GitHub Actions

[WIP]
This package provides two GitHub Actions steps for use in your pipelines.

1. Validate that your commit names meet the correct format. 
You can utilise this for pull request titles when squashing commits into a main branch.
You can also use it to validate a list of commits when using merge commits or rebasing.

2. Determine the correct value to increment your version number by when a merge has completed. 
(i.e. increment `MAJOR` for breaking change, `MINOR` for features, `PATCH` for fixes)

### Swift Package Manager

1. Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/oliver-binns/versioning", from: "1.0.0"),
```

2. Add `Versioning` as a dependency for your target:

```swift
.target(name: "MyTarget", dependencies: [
    .product(name: "Versioning", package: "versioning")
]),
```

3. `import Versioning` in your source code.

## Contributing

Pull requests and feature requests are welcome.

Obviously [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) are required for each pull request to ensure that release versioning can be managed automatically.
Please ensure that you have enabled the Git hooks, so that you don't get caught out!:
```
git config core.hooksPath hooks
```
