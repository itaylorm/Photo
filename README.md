# Photo
Application for working with photo library on an iPhone. Currently has basic project structure. Work in progress

# Third Party Libraries
1. Open Terminal
2. Install CocoaPods - Sudo gem install cocoapods
3. Clone Project to your machine
4. Open terminal in the directory where you copied the project (The one that has the .xcodeproj in it)
5. Run 'Pod init' If you don't have Pods installed
6. Run 'Pod install' to copy down the different dependencies
7. Open project with the Photo.xcworkspace NOT the Photo.xcodeproj

# Swift Lint
The only third party project is SwiftLint for syntax checking. You can learn more about this tool at https://academy.realm.io/posts/slug-jp-simard-swiftlint/

# Technologies
## PhotoKit Support
This application uses PhotoKit to provide access to the photos in user photo library

## Date Extensions
The Extensions directory contains common fuctions for working with dates

# Unit Tests
There are unit tests for many of the types in the project. I will be adding more over time. When possible I build the tests first for TDD
