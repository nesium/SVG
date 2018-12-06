//
//  ContentModeTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import SVG
import XCTest

final class ContentModeTests: XCTestCase {
  func testSmallerElementInLargerElement() {
    let /* targetElementSize */ t = CGSize(width: 100, height: 100)
    let /* sourceElementSize */ s = CGSize(width: 10, height: 20)

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .scaleToFill),
      CGRect(x: 0, y: 0, width: 100, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .scaleAspectFit),
      CGRect(x: 25, y: 0, width: 50, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 20, height: 10),
        in: t,
        with: .scaleAspectFit
      ),
      CGRect(x: 0, y: 25, width: 100, height: 50)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 20, height: 20),
        in: t,
        with: .scaleAspectFit
      ),
      CGRect(x: 0, y: 0, width: 100, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: s,
        in: t,
        with: .scaleAspectFill
      ),
      CGRect(x: 0, y: -50, width: 100, height: 200)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 20, height: 10),
        in: t,
        with: .scaleAspectFill),
      CGRect(x: -50, y: 0, width: 200, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 20, height: 20),
        in: t,
        with: .scaleAspectFill
      ),
      CGRect(x: 0, y: 0, width: 100, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .center),
      CGRect(x: 45, y: 40, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .top),
      CGRect(x: 45, y: 0, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .bottom),
      CGRect(x: 45, y: 80, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .left),
      CGRect(x: 0, y: 40, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .right),
      CGRect(x: 90, y: 40, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .topLeft),
      CGRect(x: 0, y: 0, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .topRight),
      CGRect(x: 90, y: 0, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .bottomLeft),
      CGRect(x: 0, y: 80, width: 10, height: 20)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .bottomRight),
      CGRect(x: 90, y: 80, width: 10, height: 20)
    )
  }

  func testLargerElementInLargerElement() {
    let /* targetElementSize */ t = CGSize(width: 100, height: 100)
    let /* sourceElementSize */ s = CGSize(width: 150, height: 300)

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .scaleToFill),
      CGRect(x: 0, y: 0, width: 100, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .scaleAspectFit),
      CGRect(x: 25, y: 0, width: 50, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 300, height: 150),
        in: t,
        with: .scaleAspectFit
      ),
      CGRect(x: 0, y: 25, width: 100, height: 50)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 300, height: 300),
        in: t,
        with: .scaleAspectFit
      ),
      CGRect(x: 0, y: 0, width: 100, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .scaleAspectFill),
      CGRect(x: 0, y: -50, width: 100, height: 200)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 300, height: 150),
        in: t,
        with: .scaleAspectFill
      ),
      CGRect(x: -50, y: 0, width: 200, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(
        with: CGSize(width: 300, height: 300),
        in: t,
        with: .scaleAspectFill
      ),
      CGRect(x: 0, y: 0, width: 100, height: 100)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .center),
      CGRect(x: -25, y: -100, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .top),
      CGRect(x: -25, y: 0, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .bottom),
      CGRect(x: -25, y: -200, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .left),
      CGRect(x: 0, y: -100, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .right),
      CGRect(x: -50, y: -100, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .topLeft),
      CGRect(x: 0, y: 0, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .topRight),
      CGRect(x: -50, y: 0, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .bottomLeft),
      CGRect(x: 0, y: -200, width: 150, height: 300)
    )

    XCTAssertEqual(
      ContentMode.boundsForElement(with: s, in: t, with: .bottomRight),
      CGRect(x: -50, y: -200, width: 150, height: 300)
    )
  }
}
