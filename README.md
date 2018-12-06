# SVG

No-frills library to render a subset of SVG into images. Written in Swift.

Supports all basic shapes and the path element. Solid colors only.

This library is great when iterating over an UI where the final decision on icon sizes and colors hasn't been made. Probably beyond.

The SVGs are measured by their specified `viewBox`. Your designer thinks this is a good thing.

---

### Use it like so:

```swift
let imageView = UIImageView(image: UIImage.svg_named("YOUR_SVG"))
self.addSubview(imageView)
```

### If you're SVG hasn't the right target size, resize it:

```swift
let imageView = UIImageView(image:
  UIImage.svg_named(
    "YOUR_SVG",
    size: .fixed(CGSize(width: 48, height: 48), .scaleAspectFit)
  )
)
self.addSubview(imageView)
```

### Set a background color:

```swift
let imageView = UIImageView(image:
  UIImage.svg_named("YOUR_SVG", backgroundColor: .white)
)
self.addSubview(imageView)
```

### Change the color of parts of your SVG:

```swift
let img = UIImage.svg_named("badge") { element, id, className, proposedStyle in
  switch id {
    case "circle":
      return Style(fillColor: UIColor(red:0.92, green:0.27, blue:0.35, alpha:1.0).cgColor)

    case "rect":
      return Style(fillColor: UIColor.gray.cgColor)

    default:
      return proposedStyle
  }
}
```

Which gives you the following:

|               Before               |                   After                   |
| :--------------------------------: | :---------------------------------------: |
| ![Badge before](.github/badge.png) | ![Badge after](.github/badge_colored.png) |

### And finally, generate a bezier path from a SVG path string

```swift
UIBezierPath.svg_fromPath(string: "M150 0 L75 200 L225 200 Z")
```
