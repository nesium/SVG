//
//  ContentModeImageTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 05.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import SVG
import UIKit
import XCTest
import SnapshotTesting

final class ContentModeImageTests: XCTestCase {
  func testOriginalOutputSize() {
    assertSnapshot(matching: imageFromSVG("rect", size: .original), as: .image)
  }

  func testFixedOutputSizeWithLargerOutput() {
    let t = CGSize(width: 200, height: 200)
    let c = UIColor.white.cgColor

    let image = { (mode: ContentMode) -> UIImage in
      imageFromSVG("rect", size: .fixed(t, mode), backgroundColor: c)
    }

    assertSnapshot(matching: image(.scaleToFill), as: .image, named: "scaleToFill")
    assertSnapshot(matching: image(.scaleAspectFit), as: .image, named: "scaleAspectFit")
    assertSnapshot(matching: image(.scaleAspectFill), as: .image, named: "scaleAspectFill")
    assertSnapshot(matching: image(.center), as: .image, named: "center")
    assertSnapshot(matching: image(.top), as: .image, named: "top")
    assertSnapshot(matching: image(.bottom), as: .image, named: "bottom")
    assertSnapshot(matching: image(.left), as: .image, named: "left")
    assertSnapshot(matching: image(.right), as: .image, named: "right")
    assertSnapshot(matching: image(.topLeft), as: .image, named: "topLeft")
    assertSnapshot(matching: image(.topRight), as: .image, named: "topRight")
    assertSnapshot(matching: image(.bottomLeft), as: .image, named: "bottomLeft")
    assertSnapshot(matching: image(.bottomRight), as: .image, named: "bottomRight")
  }

  func testFixedOutputSizeWithSmallerOutput() {
    let t = CGSize(width: 40, height: 40)
    let c = UIColor.white.cgColor

    let image = { (mode: ContentMode) -> UIImage in
      imageFromSVG("rect", size: .fixed(t, mode), backgroundColor: c)
    }

    assertSnapshot(matching: image(.scaleToFill), as: .image, named: "scaleToFill")
    assertSnapshot(matching: image(.scaleAspectFit), as: .image, named: "scaleAspectFit")
    assertSnapshot(matching: image(.scaleAspectFill), as: .image, named: "scaleAspectFill")
    assertSnapshot(matching: image(.center), as: .image, named: "center")
    assertSnapshot(matching: image(.top), as: .image, named: "top")
    assertSnapshot(matching: image(.bottom), as: .image, named: "bottom")
    assertSnapshot(matching: image(.left), as: .image, named: "left")
    assertSnapshot(matching: image(.right), as: .image, named: "right")
    assertSnapshot(matching: image(.topLeft), as: .image, named: "topLeft")
    assertSnapshot(matching: image(.topRight), as: .image, named: "topRight")
    assertSnapshot(matching: image(.bottomLeft), as: .image, named: "bottomLeft")
    assertSnapshot(matching: image(.bottomRight), as: .image, named: "bottomRight")
  }

  func testScaledOutputSize() {
    assertSnapshot(matching: imageFromSVG("rect", size: .scaled(3)), as: .image)
  }

  func testColorGroupWithStyleOverride() {
    assertSnapshot(
      matching: imageFromSVG("badge") { element, _, _, proposedStyle in
        if element == .group {
          return Style(
            fillColor: UIColor.yellow.cgColor,
            strokeColor: UIColor.red.cgColor,
            strokeWidth: 2
          )
        }
        return proposedStyle
      },
      as: .image
    )
  }

  func testSkipElementWithStyleOverride() {
    assertSnapshot(
      matching: imageFromSVG("badge") { _, id, _, proposedStyle in
        if id == "circle" {
          return Style()
        }
        return proposedStyle
      },
      as: .image
    )
  }

  func testColorElementsWithStyleOverride() {
    assertSnapshot(
      matching: imageFromSVG("badge") { _, id, _, proposedStyle in
        switch id {
          case "circle":
            return Style(fillColor: UIColor(red:0.92, green:0.27, blue:0.35, alpha:1.0).cgColor)

          case "rect":
            return Style(fillColor: UIColor.gray.cgColor)

          default:
            return proposedStyle
        }
      },
      as: .image
    )
  }

  func testScreenScale() {
    assertSnapshot(
      matching: imageFromSVG(
        "rect",
        size: .original,
        screenScale: 3,
        backgroundColor: UIColor.white.cgColor
      ),
      as: .image
    )
    assertSnapshot(
      matching: imageFromSVG(
        "rect",
        size: .fixed(CGSize(width: 200, height: 200), .center),
        screenScale: 3,
        backgroundColor: UIColor.white.cgColor
      ),
      as: .image
    )
    assertSnapshot(
      matching: imageFromSVG(
        "rect",
        size: .scaled(3),
        screenScale: 3,
        backgroundColor: UIColor.white.cgColor
      ),
      as: .image
    )
  }
}
