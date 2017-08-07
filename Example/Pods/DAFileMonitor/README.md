# DAFileMonitor

[![Version](https://img.shields.io/cocoapods/v/DAFileMonitor.svg?style=flat)](http://cocoapods.org/pods/DAFileMonitor)
[![License](https://img.shields.io/cocoapods/l/DAFileMonitor.svg?style=flat)](http://cocoapods.org/pods/DAFileMonitor)
[![Platform](https://img.shields.io/cocoapods/p/DAFileMonitor.svg?style=flat)](http://cocoapods.org/pods/DAFileMonitor)

## Usage

```swift
var fileMonitor = DAFileMonitor(withFilePath: filePath)
fileMonitor?.onFileEvent = {
    // This closure is called when your file changes.
}
```

## Installation

DAFileMonitor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DAFileMonitor"
```

## Author

Dejan Agostini, dejan.agostini@gmail.com

## License

DAFileMonitor is available under the MIT license. See the LICENSE file for more info.
