# Charlotte

Charlotte is a library for creating interactive charts on iOS.

## Development
To contribute to the Charlotte framework or run unit tests, use the Charlotte framework workspace.
```
$ cd Charlotte
$ open Charlotte.xcworkspace
```
To add or modify an example, open the workspace in the `Examples` directory. Charlotte is included as a local development pod, so you will only need to run `pod install` whenever you add or remove files in the Charlotte framework.

## Updating
To push an updated version:

1. Update the version in `Charlotte.podspec`
2. Create a release branch (e.g. `release/v7.2.0`)
3. When ready, merge your release branch into master
4. Create a tag (on master)
- `git tag -a v7.2.0 -m "Bugfixes"`
- `git push --tags`
5. Push the updated podspec to our private repo
- `pod repo push florida Charlotte.podspec --allow-warnings`
6. Merge your release branch back into develop
