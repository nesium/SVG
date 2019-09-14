//
//  W3CoordTransTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import XCTest
import SnapshotTesting

final class W3CoordTransTests: XCTestCase {
  func testCoords1() {
    assertSnapshot(matching: imageFromSVG("coords-trans-01-t"), as: .image)
  }

  func testCoords2() {
    assertSnapshot(matching: imageFromSVG("coords-trans-02-t"), as: .image)
  }

  func testCoords3() {
    assertSnapshot(matching: imageFromSVG("coords-trans-03-t"), as: .image)
  }

  func testCoords4() {
    assertSnapshot(matching: imageFromSVG("coords-trans-04-t"), as: .image)
  }

  func testCoords5() {
    assertSnapshot(matching: imageFromSVG("coords-trans-05-t"), as: .image)
  }

  func testCoords6() {
    assertSnapshot(matching: imageFromSVG("coords-trans-06-t"), as: .image)
  }

  func testCoords7() {
    assertSnapshot(matching: imageFromSVG("coords-trans-07-t"), as: .image)
  }

  func testCoords8() {
    assertSnapshot(matching: imageFromSVG("coords-trans-08-t"), as: .image)
  }

  func testCoords9() {
    assertSnapshot(matching: imageFromSVG("coords-trans-09-t"), as: .image)
  }
}
