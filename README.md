# CirculoMenu
Menu with a circular layout based on lovely [Macaw](https://github.com/exyte/macaw).

<img src="http://i.imgur.com/G2Gbkf8.gif" height="370">

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

// show buttons on the half circle
circleMenuView.halfMode = true
```

## Installation

### [CocoaPods](http://cocoapods.org)

To install it, simply add the following line to your Podfile:
```ruby
pod "CirculoMenu", "0.6.0"
```

### [Carthage](http://github.com/Carthage/Carthage)

```ogdl
github "Exyte/CirculoMenu" ~> 0.6.0
```

### Manually

Drop [CircleMenuView.swift](https://github.com/exyte/CirculoMenu/blob/master/Circulo/CircleMenuView.swift) in your project.

## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 7.3+

## Author

This project is maintained by the [exyte](https://www.exyte.com) company, a team of experienced software engineers from the cold Siberia. We don't have bears and don't like vodka, but we love to create great applications. Just [contact us](mailto:info@exyte.com).
