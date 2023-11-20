# Versioning

A Swift Package for enforcing Conventional Commits and managing versions.

## Usage

### GitHub Actions

This package provides two types of GitHub Action steps for use in your pipelines.

1. Validate that your commit names meet the correct format. 
You can utilise this for pull request titles when squashing commits into a main branch.
You can also use it to validate a list of commits when using merge commits or rebasing.

```
...
steps:
  - uses: actions/checkout@v4
  
  - name: Validate Pull Request Name
    id: versioning
    uses: Oliver-Binns/Versioning@main
    with:
      ACTION_TYPE: 'Validate'
        
```

2. Release new version when you merge code based on the conventional commit used.
(i.e. increment `MAJOR` for breaking change, `MINOR` for features, `PATCH` for fixes)

Ensure you have specified a GitHub token with write permissions:

```
jobs:
  job_id:
    name: Increment version number
    runs-on: macos-13
    permissions:
      contents: write
```

And pass the GitHub Token as a parameter:

```
- name: Increment Version
  id: versioning
  uses: Oliver-Binns/Versioning@main
  with:
    ACTION_TYPE: 'Release'
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

The release action outputs the version number it has released.
You can access it using the GitHub output values:

```
echo ${{ steps.versioning.outputs.release_version }}
```

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
