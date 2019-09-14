//
//  W3ShapeTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import XCTest
import SnapshotTesting

final class W3ShapeTests: XCTestCase {
  func testCircle() {
    assertSnapshot(matching: imageFromSVG("shapes-circle-01-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-circle-02-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-circle-03-t"), as: .image)
  }

  func testEllipse() {
    assertSnapshot(matching: imageFromSVG("shapes-ellipse-01-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-ellipse-02-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-ellipse-03-t"), as: .image)
  }

  func testLine() {
    assertSnapshot(matching: imageFromSVG("shapes-line-01-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-line-02-t"), as: .image)
  }

  func testPolygon() {
    assertSnapshot(matching: imageFromSVG("shapes-polygon-01-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-polygon-02-t"), as: .image)
  }

  func testPolyline() {
    assertSnapshot(matching: imageFromSVG("shapes-polyline-01-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-polyline-02-t"), as: .image)
  }

  func testRect() {
    assertSnapshot(matching: imageFromSVG("shapes-rect-01-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-rect-02-t"), as: .image)
    assertSnapshot(matching: imageFromSVG("shapes-rect-03-t"), as: .image)
  }

  func testEmptyShapes() {
    assertSnapshot(matching: imageFromSVG("shapes-intro-01-t"), as: .image)
  }
}
