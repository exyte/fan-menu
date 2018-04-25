# FanMenu

[![Version](https://img.shields.io/cocoapods/v/FanMenu.svg?style=flat)](http://cocoapods.org/pods/FanMenu)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-0473B3.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/FanMenu.svg?style=flat)](http://cocoapods.org/pods/FanMenu)
[![Platform](https://img.shields.io/cocoapods/p/FanMenu.svg?style=flat)](http://cocoapods.org/pods/FanMenu)

Menu with a circular layout based on [Macaw](https://github.com/exyte/Macaw). This project is maintained by [exyte](https://www.exyte.com).

<img src="http://i.imgur.com/o6tBKW6.gif" height="500"> <img src="http://i.imgur.com/Hg0GWAz.gif" height="500"> <img src="http://i.imgur.com/erRavyB.gif" height="500">

# Usage
1. Create `UIView` in your storyboard or programatically.
2. Set `FanMenu` as `UIView` class.
3. Set button
```swift
fanMenu.button = FanMenuButton(
  id: "main",
  image: "plus",
  color: Color(val: 0x7C93FE)
)
```
4. Set menu items
```swift
fanMenu.items = [
  FanMenuButton(
    id: "exchange_id",
    image: "exchange",
    color: Color(val: 0x9F85FF)
  ),
  ...
  FanMenuButton(
    id: "visa_id",
    image: "visa",
    color: Color(val: 0xF55B58)
  )
]
```
5. Add event handler
```swift
// call before animation
fanMenu.onItemDidClick = { button in
  print("ItemDidClick: \(button.id)")
}
// call after animation
fanMenu.onItemWillClick = { button in
  print("ItemWillClick: \(button.id)")
}
```
6. Configure optional parameters
```swift
// distance between button and items
fanMenu.menuRadius = 90.0

// animation duration
fanMenu.duration = 0.35

// menu opening delay
fanMenu.delay = 0.05

// interval for buttons in radians
fanMenu.interval = (0, 2.0 * M_PI)

// menu background color
fanMenu.menuBackground = Color.red
```

7. Useful methods
```swift
fanMenu.isOpen
fanMenu.open()
fanMenu.close()
```

## Customization

FanMenu bases on [Macaw](https://github.com/exyte/Macaw), vector graphics Swift library. Because of that fan-menu could be easily modified and improved for your purposes.

All source code is in one single file called FanMenu.swift. To modify menu simply copy this file and apply necessary changes. With fan-menu and Macaw you could make awesome menus!

<img src="http://i.imgur.com/1JXF60f.gif" height="500">

## Examples

To try fan-menu examples:
- Clone the repo `git@github.com:exyte/fan-menu.git`
- Open terminal and run `cd <FanMenuRepo>/Example/`
- Run `pod install` to install all dependencies
- Run open `FanMenu.xcworkspace/` to open project in the Xcode
- Try it!

We have next examples:

- [FinanceViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/FinanceViewController.swift)
Accounting & Financial Management. Inspired by [Yingfang Xie](https://dribbble.com/Melodyblue).
- [TaskViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/TaskViewController.swift)
Color Coding Microinteraction. Insipred by [Filippos Protogeridis](https://dribbble.com/protogeridis).
- [ShopViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/ShopViewController.swift)
Inspired by [Tice](https://dribbble.com/Tice).
- [CustomViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/CustomViewController.swift) Inspired by awesome Ramotion control [circle-menu](https://github.com/Ramotion/circle-menu)

## Installation

*CocoaPods*

```ruby
pod "FanMenu"
```

*Carthage*

## [Carthage](http://github.com/Carthage/Carthage)

```ogdl
github "Exyte/fan-menu"
```

*Manually*

Drop [FanMenu.swift](https://github.com/exyte/fan-menu/blob/master/Sources/FanMenu.swift) in your project.

## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 8.0+

## Author

This project is maintained by [exyte](https://www.exyte.com). We design and build mobile and VR/AR applications.
