# BBPortal

[![Version](https://img.shields.io/cocoapods/v/BBPortal.svg?style=flat)](http://cocoapods.org/pods/BBPortal)
[![License](https://img.shields.io/cocoapods/l/BBPortal.svg?style=flat)](http://cocoapods.org/pods/BBPortal)
[![Platform](https://img.shields.io/cocoapods/p/BBPortal.svg?style=flat)](http://cocoapods.org/pods/BBPortal)

## Description

BBPortal is a library that will enable you to pass data between your targets and applications (excluding the watch target). It's using App Groups in the background to save data in the shared container and another library (DAFileMonitor) is used to listen to changes on the file. You can create as many portals as you want. You can give your portals different IDs or you can give them all the same ID. When you push data through your portal, all other portals with the same ID will receive the data.

## Usage

```swift
var portal: BBPortalProtocol = BBPortal(withGroupIdentifier: "your.group.identifier.goes.here", andPortalID: "id.for.this.portal")

// Send data
portal.send(data: ["key": "What ever data you want"]) { 
    (error) in

    if let anError = error {
        print("Send failed with error: ", anError)
    }
}

// Receive data
portal.onDataAvailable = {
    (data) in

    guard let dict = data as? [String: Any?] else {
        return
    }

    print("I received some data through the portal: ", dict)
}
```

## Installation

BBPortal is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BBPortal'
```

## Author

Dejan Agostini, dejan.agostini@gmail.com

## License

BBPortal is available under the MIT license. See the LICENSE file for more info.
