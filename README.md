<img src="https://github.com/exyte/fan-menu/blob/master/header.png">
<img align="right" src="https://raw.githubusercontent.com/exyte/fan-menu/master/demo.gif" width="480" />

<p><h1 align="left">FanMenu</h1></p>

<p><h4>Easily customizable floating circle menu created with <a href="https://github.com/exyte/Macaw">Macaw</a></h4></p>

___

<p> We are a development agency building
  <a href="https://clutch.co/profile/exyte#review-731233">phenomenal</a> apps.</p>

</br>

<a href="https://exyte.com/contacts"><img src="https://i.imgur.com/vGjsQPt.png" width="134" height="34"></a> <a href="https://twitter.com/exyteHQ"><img src="https://i.imgur.com/DngwSn1.png" width="165" height="34"></a>

</br></br>

[![Twitter](https://img.shields.io/badge/Twitter-@exyteHQ-blue.svg?style=flat)](http://twitter.com/exyteHQ)
[![Version](https://img.shields.io/cocoapods/v/FanMenu.svg?style=flat)](http://cocoapods.org/pods/FanMenu)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-0473B3.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/FanMenu.svg?style=flat)](http://cocoapods.org/pods/FanMenu)
[![Platform](https://img.shields.io/cocoapods/p/FanMenu.svg?style=flat)](http://cocoapods.org/pods/FanMenu)

# Usage
1. Create `UIView` in your storyboard or programatically.
2. Set `FanMenu` as `UIView` class.
3. Set the button
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
5. Add an event handler
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

FanMenu is created with [Macaw](https://github.com/exyte/Macaw), our vector graphics Swift library. Thanks to that, it can be easily modified and improved for your purposes.

All source code is located in one single file called FanMenu.swift. To modify the menu simply copy this file and apply necessary changes.

<img src="http://i.imgur.com/1JXF60f.gif" height="500">

## Examples

To try out the FanMenu examples:
- Clone the repo `git clone git@github.com:exyte/fan-menu.git`
- Open terminal and run `cd <FanMenuRepo>/Example`
- Run `pod install` to install all dependencies
- Run `xed .` to open project in the Xcode
- Try it!

We have the following examples:

- [FinanceViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/FinanceViewController.swift)
Accounting & Financial Management. Inspired by [Yingfang Xie](https://dribbble.com/Melodyblue).
- [TaskViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/TaskViewController.swift)
Color Coding Microinteraction. Insipred by [Filippos Protogeridis](https://dribbble.com/protogeridis).
- [ShopViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/ShopViewController.swift)
Inspired by [Tice](https://dribbble.com/Tice).
- [CustomViewController.swift](https://github.com/exyte/fan-menu/blob/master/Example/Example/CustomViewController.swift) Inspired by awesome Ramotion control [circle-menu](https://github.com/Ramotion/circle-menu)

## Installation

### CocoaPods

```ruby
pod 'FanMenu'
```

### Carthage

```ogdl
github 'Exyte/fan-menu'
```

### Manually

Drop [FanMenu.swift](https://github.com/exyte/fan-menu/blob/master/Sources/FanMenu.swift) into your project.

## Requirements

* iOS 9.0+ / macOS 10.12+
* Xcode 10.2+
