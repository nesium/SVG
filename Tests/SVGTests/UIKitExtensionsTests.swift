//
//  UIKitExtensionsTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 06.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import SVG
import XCTest
import SnapshotTesting

final class UIKitExtensionsTests: XCTestCase {
  func testBezierPathFromSVGPath() {
    let bezierPath = UIBezierPath.svg_fromPath(string: "M150 0 L75 200 L225 200 Z")
    assertSnapshot(matching: bezierPath, as: .dump)
  }

  func testSVGNamed() {
    let img = UIImage.svg_named("rect.svg", in: Bundle.testBundle)!
    XCTAssertEqual(img.size.width, 100)
    XCTAssertEqual(img.size.height, 50)
    XCTAssertEqual(img.cgImage!.width, Int(100 * UIScreen.main.scale))
    XCTAssertEqual(img.cgImage!.height, Int(50 * UIScreen.main.scale))
  }
}
