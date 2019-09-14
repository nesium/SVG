//
//  W3PathsTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import XCTest
import SnapshotTesting

final class W3PathsTests: XCTestCase {
  func testPaths1() {
    assertSnapshot(matching: imageFromSVG("paths-data-01-t"), as: .image)
  }

  func testPaths2() {
    assertSnapshot(matching: imageFromSVG("paths-data-02-t"), as: .image)
  }

  func testPaths3() {
    assertSnapshot(matching: imageFromSVG("paths-data-03-f"), as: .image)
  }

  func testPaths4() {
    assertSnapshot(matching: imageFromSVG("paths-data-04-t"), as: .image)
  }

  func testPaths5() {
    assertSnapshot(matching: imageFromSVG("paths-data-05-t"), as: .image)
  }

  func testPaths6() {
    assertSnapshot(matching: imageFromSVG("paths-data-06-t"), as: .image)
  }

  func testPaths7() {
    assertSnapshot(matching: imageFromSVG("paths-data-07-t"), as: .image)
  }

  func testPaths8() {
    assertSnapshot(matching: imageFromSVG("paths-data-08-t"), as: .image)
  }

  func testPaths9() {
    assertSnapshot(matching: imageFromSVG("paths-data-09-t"), as: .image)
  }

  func testPaths10() {
    assertSnapshot(matching: imageFromSVG("paths-data-10-t"), as: .image)
  }

  func testPaths12() {
    assertSnapshot(matching: imageFromSVG("paths-data-12-t"), as: .image)
  }

  func testPaths13() {
    assertSnapshot(matching: imageFromSVG("paths-data-13-t"), as: .image)
  }

  func testPaths14() {
    assertSnapshot(matching: imageFromSVG("paths-data-14-t"), as: .image)
  }

  func testPaths15() {
    assertSnapshot(matching: imageFromSVG("paths-data-15-t"), as: .image)
  }
}
