# CirculoMenu
Menu with a circular layout based on lovely [Macaw](https://github.com/exyte/macaw).

<img src="http://i.imgur.com/ihN9FIb.gif" height="500"> <img src="http://i.imgur.com/ZHTmtcn.gif" height="500"> <img src="http://i.imgur.com/KslbTC5.gif" height="500">

# Usage
1. Create `UIView` in your storyboard or programatically.
2. Set `CircleMenuView` as `UIView` class.
3. Set center button
```swift
circleMenuView.centerButton = CircleMenuButton(
 id: "main",
 image: "plus",
 color: Color(val: 0x7C93FE)
)
```
4. Set circle buttons
```swift
circleMenuView.buttons = [
 CircleMenuButton(
  id: "exchange_id",
  image: "exchange",
  color: Color(val: 0x9F85FF)
 ),
 ...
 CircleMenuButton(
  id: "visa_id",
  image: "visa",
  color: Color(val: 0xF55B58)
 )
]
```
5. Add event handler
```swift
 circleMenuView.onButtonPressed = { button in
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
circleMenuView.distance = 90.0

// animation duration
circleMenuView.duration = 0.35

// interval for buttons, in radians
circleMenuView.interval = (0, 2.0 * M_PI)
```

## Customization

CirculoMenu bases on [Macaw](https://github.com/exyte/Macaw), vector graphics Swift library. Because of that CirculoMenu could be easily modified and improved for your purposes. 

All source code is in one single file called CircleMenuView.swift. To modify menu simply copy this file and apply necessary changes. With CircleMenu and Macaw you could make awesome menus!

<img src="http://i.imgur.com/w2OK6Db.gif" height="500">

## Examples

To try CirculoMenu examples:
- Clone the repo `git@github.com:exyte/Macaw.git`
- Open terminal and run `cd <CirculoMenuRepo>/`
- Run `pod install` to install all dependencies
- Run open `CirculoMenu.xcworkspace/` to open project in the Xcode
- Select required controller as Initial Controller in storyboard
- Try it!

We have next examples:

- [FinanceViewController.swift](https://github.com/exyte/CirculoMenu/blob/master/Circulo/FinanceViewController.swift)
Accounting & Financial Management. Inspired by [Yingfang Xie](https://dribbble.com/Melodyblue).
- [TaskViewController.swift](https://github.com/exyte/CirculoMenu/blob/master/Circulo/TaskViewController.swift)
Color Coding Microinteraction. Insipred by [Filippos Protogeridis](https://dribbble.com/protogeridis).
- [ShopViewController.swift](https://github.com/exyte/CirculoMenu/blob/master/Circulo/ShopViewController.swift)
Inspired by [Tice](https://dribbble.com/Tice).

## Installation

*CocoaPods*

```ruby
pod "CirculoMenu", "0.6.0"
```

*Carthage*

```ogdl
github "Exyte/CirculoMenu" ~> 0.6.0
```

*Manually*

Drop [CircleMenuView.swift](https://github.com/exyte/CirculoMenu/blob/master/Circulo/CircleMenuView.swift) in your project.

## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 7.3+

## Author

This project is maintained by the [exyte](https://www.exyte.com) company, a team of experienced software engineers from the cold Siberia. We don't have bears and don't like vodka, but we love to create great applications. Just [contact us](mailto:info@exyte.com).
