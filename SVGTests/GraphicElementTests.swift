//
//  GraphicElementTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 03.12.18.
//

import XCTest
import SnapshotTesting

final class GraphicElementTests: XCTestCase {
  func testRectangle() {
    assertSnapshot(matching: imageFromSVG("rectangles"), as: .image)
  }

  func testCircle() {
    assertSnapshot(matching: imageFromSVG("circles"), as: .image)
  }

  func testEllipse() {
    assertSnapshot(matching: imageFromSVG("ellipses"), as: .image)
  }

  func testPath() {
    assertSnapshot(matching: imageFromSVG("paths"), as: .image)
  }

  func testEllipticalArcs() {
    assertSnapshot(matching: imageFromSVG("elliptical_arcs_1"), as: .image)
    assertSnapshot(matching: imageFromSVG("elliptical_arcs_2"), as: .image)
  }

  func testNestedGroup() {
    assertSnapshot(matching: imageFromSVG("nested_group", size: .scaled(3)), as: .image)
  }

  func testTiger() {
    assertSnapshot(matching: imageFromSVG("tiger"), as: .image)
  }
}
