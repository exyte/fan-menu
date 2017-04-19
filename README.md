# FanMenu
Menu with a circular layout based on [Macaw](https://github.com/exyte/Macaw). This project is maintained by the [exyte](https://www.exyte.com) company.

<img src="http://i.imgur.com/ihN9FIb.gif" height="500"> <img src="http://i.imgur.com/ZHTmtcn.gif" height="500"> <img src="http://i.imgur.com/KslbTC5.gif" height="500">

# Usage
1. Create `UIView` in your storyboard or programatically.
2. Set `FanMenuView` as `UIView` class.
3. Set center button
```swift
fanMenuView.centerButton = FanMenuButton(
  id: "main",
  image: "plus",
  color: Color(val: 0x7C93FE)
)
```
4. Set buttons
```swift
fanMenuView.buttons = [
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
 fanMenuView.onButtonPressed = { button in
  switch button.id {
    case "exchange_id":
      print("open exchange screen")
    case "visa_id":
      print("open cards screen")
    default:
      print("other")
  }
}
```
6. Configure optional parameters
```swift
// distance between center button and buttons
fanMenuView.distance = 90.0

// animation duration
fanMenuView.duration = 0.35

// interval for buttons in radians
fanMenuView.interval = (0, 2.0 * M_PI)
```

7. Useful methods
```swift
fanMenuView.menu.isOpen
fanMenuView.menu.open()
fanMenuView.menu.close()
```

## Customization

FanMenu bases on [Macaw](https://github.com/exyte/Macaw), vector graphics Swift library. Because of that FanMenu could be easily modified and improved for your purposes. 

All source code is in one single file called FanMenuView.swift. To modify menu simply copy this file and apply necessary changes. With FanMenu and Macaw you could make awesome menus!

<img src="http://i.imgur.com/w2OK6Db.gif" height="500">

## Examples

To try FanMenu examples:
- Clone the repo `git@github.com:exyte/FanMenu.git`
- Open terminal and run `cd <FanMenuRepo>/`
- Run `pod install` to install all dependencies
- Run open `FanMenu.xcworkspace/` to open project in the Xcode
- Select required controller as Initial Controller in storyboard
- Try it!

We have next examples:

- [FinanceViewController.swift](https://github.com/exyte/FanMenu/blob/master/FanMenu/FinanceViewController.swift)
Accounting & Financial Management. Inspired by [Yingfang Xie](https://dribbble.com/Melodyblue).
- [TaskViewController.swift](https://github.com/exyte/FanMenu/blob/master/FanMenu/TaskViewController.swift)
Color Coding Microinteraction. Insipred by [Filippos Protogeridis](https://dribbble.com/protogeridis).
- [ShopViewController.swift](https://github.com/exyte/FanMenu/blob/master/FanMenu/ShopViewController.swift)
Inspired by [Tice](https://dribbble.com/Tice).
- [CustomViewController.swift](https://github.com/exyte/CirculoMenu/blob/master/Circulo/CustomViewController.swift) Inspired by awesome Ramotion control [circle-menu](https://github.com/Ramotion/circle-menu)

## Installation

*CocoaPods*

```ruby
pod "~> FanMenu", "0.6.0"
```

*Carthage*

```ogdl
github "Exyte/FanMenu" ~> 0.6.0
```

*Manually*

Drop [FanMenuView.swift](https://github.com/exyte/CirculoMenu/blob/master/FanMenu/FanMenuView.swift) in your project.

## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 8.0+

## Author

This project is maintained by the [exyte](https://www.exyte.com) company, a team of experienced software engineers from the cold Siberia. We don't have bears and don't like vodka, but we love to create great applications. Just [contact us](mailto:info@exyte.com).
