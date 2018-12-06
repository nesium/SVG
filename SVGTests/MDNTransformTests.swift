//
//  MDNTransformTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import XCTest
import SnapshotTesting

final class MDNTransformTests: XCTestCase {
  func testTranslate() {
    assertSnapshot(matching: imageFromSVG("transform_translate"), as: .image)
  }

  func testScale() {
    assertSnapshot(matching: imageFromSVG("transform_scale"), as: .image)
  }

  func testRotate() {
    assertSnapshot(matching: imageFromSVG("transform_rotate"), as: .image)
  }

  func testSkewX() {
    assertSnapshot(matching: imageFromSVG("transform_skewx"), as: .image)
  }

  func testSkewY() {
    assertSnapshot(matching: imageFromSVG("transform_skewy"), as: .image)
  }

  func testMatrix() {
    assertSnapshot(matching: imageFromSVG("transform_matrix"), as: .image)
  }

  func testCombination() {
    assertSnapshot(matching: imageFromSVG("transform_combination"), as: .image)
  }
}
