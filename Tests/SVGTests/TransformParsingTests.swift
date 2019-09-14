//
//  TransformParsingTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import XCTest
import SnapshotTesting

@testable import SVG

final class TransformParsingTests: XCTestCase {
  func testParseTranslate() {
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "translate(100, 20)"),
      CGAffineTransform(translationX: 100, y: 20)
    )
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "translate(100)"),
      CGAffineTransform(translationX: 100, y: 0)
    )
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "translate(30 20)"),
      CGAffineTransform(translationX: 30, y: 20)
    )
  }

  func testParseScale() {
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "scale(100, 20)"),
      CGAffineTransform(scaleX: 100, y: 20)
    )
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "scale(100)"),
      CGAffineTransform(scaleX: 100, y: 100)
    )
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "scale(30 20)"),
      CGAffineTransform(scaleX: 30, y: 20)
    )
  }

  func testParseRotate() {
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "rotate(100)"),
      CGAffineTransform(rotationAngle: 100 * (CGFloat.pi / 180))
    )
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "rotate(100, 1)"),
      CGAffineTransform(rotationAngle: 100 * (CGFloat.pi / 180))
    )
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "rotate(120, 20, 30)"),
      CGAffineTransform(translationX: 20, y: 30)
        .rotated(by: 120 * (CGFloat.pi / 180))
        .translatedBy(x: -20, y: -30)
    )
  }

  func testSkewX() {
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "skewX(36)"),
      CGAffineTransform.svg_skewX(36)
    )
  }

  func testSkewY() {
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "skewY(44)"),
      CGAffineTransform.svg_skewY(44)
    )
  }

  func testParseMatrix() {
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "matrix(3 1 -1 3 30 40)"),
      CGAffineTransform(a: 3, b: 1, c: -1, d: 3, tx: 30, ty: 40)
    )
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "matrix(0 0 0 0 0 0)"),
      CGAffineTransform(a: 0, b: 0, c: 0, d: 0, tx: 0, ty: 0)
    )
  }

  func testParseGarbage() {
    XCTAssertNil(CGAffineTransform.svg_from(string: "translate"))
    XCTAssertNil(CGAffineTransform.svg_from(string: "translate("))
    XCTAssertNil(CGAffineTransform.svg_from(string: "unknown"))
  }

  func testCombination() {
    XCTAssertEqual(
      CGAffineTransform.svg_from(string: "translate(100) scale(30 20) rotate(30)"),
      CGAffineTransform(translationX: 100, y: 0)
        .scaledBy(x: 30, y: 20)
        .rotated(by: 30 * (CGFloat.pi / 180))
    )
  }
}
