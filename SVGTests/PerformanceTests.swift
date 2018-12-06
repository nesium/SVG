//
//  PerformanceTests.swift
//  SVGTests
//
//  Created by Marc Bauer on 05.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import XCTest

@testable import SVG

final class PerformanceTests: XCTestCase {
  func testPerformance() {
    self.measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
      let data = try! Data(contentsOf: Bundle.testBundle.url(forSVG: "paths")!)

      startMeasuring()
      for _ in 1...100 {
        do {
          try Parser(data: data, renderer: ImageRenderer(outputSize: .original)).parse()
        } catch {
          fatalError(error.localizedDescription)
        }
      }
      stopMeasuring()
    }
  }
}
