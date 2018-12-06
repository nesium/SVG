//
//  ColorParsingTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import UIKit
import XCTest

@testable import SVG

final class ColorParsingTests: XCTestCase {
  func testSixDigitHexString() {
    XCTAssertEqual(CGColor.svg_from(string: "#ff00ff")?.components, [1, 0, 1, 1])
    XCTAssertEqual(CGColor.svg_from(string: "#00ff00")?.components, [0, 1, 0, 1])
    XCTAssertEqual(CGColor.svg_from(string: "#666666", opacity: 0.2)?.components, [0.4, 0.4, 0.4, 0.2])
  }

  func testThreeDigitHexString() {
    XCTAssertEqual(CGColor.svg_from(string: "#f0f")?.components, [1, 0, 1, 1])
    XCTAssertEqual(CGColor.svg_from(string: "#0f0")?.components, [0, 1, 0, 1])
    XCTAssertEqual(CGColor.svg_from(string: "#333")?.components, [0.2, 0.2, 0.2, 1])
    XCTAssertEqual(CGColor.svg_from(string: "#333", opacity: 0.7)?.components, [0.2, 0.2, 0.2, 0.7])
  }

  func testNoneColor() {
    XCTAssertEqual(CGColor.svg_from(string: "none", opacity: 0.5)?.components, [0, 0, 0, 0])
  }

  func testHTMLColors() {
    XCTAssertEqual(CGColor.svg_from(string: "red")?.components, [1, 0, 0, 1])
    XCTAssertEqual(CGColor.svg_from(string: "lime")?.components, [0, 1, 0, 1])
    XCTAssertEqual(CGColor.svg_from(string: "blue", opacity: 0.5)?.components, [0, 0, 1, 0.5])
  }
}
