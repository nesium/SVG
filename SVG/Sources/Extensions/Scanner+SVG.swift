//
//  Scanner+SVG.swift
//  SVG
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import CoreGraphics

extension Scanner {
  static func svg_scanner(string: String) -> Scanner {
    let scanner = Scanner(string: string)
    var skipChars = CharacterSet(charactersIn: ",")
    skipChars.formUnion(CharacterSet.whitespacesAndNewlines)
    scanner.charactersToBeSkipped = skipChars
    return scanner
  }

  func scanCGPoint() -> CGPoint? {
    if let x = self.scanDouble(), let y = self.scanDouble() {
      return CGPoint(x: x, y: y)
    }
    return nil
  }

  func scanCGRect() -> CGRect? {
    guard
      let x = self.scanDouble(),
      let y = self.scanDouble(),
      let w = self.scanDouble(),
      let h = self.scanDouble()
    else {
      return nil
    }
    return CGRect(x: x, y: y, width: w, height: h)
  }

  func scanCGFloat() -> CGFloat? {
    return self.scanDouble().flatMap(CGFloat.init)
  }

  func scanCGFloatArray() -> [CGFloat]? {
    guard let value = self.scanCGFloat() else {
      return nil
    }
    return self.scanCGFloatArray().map { [value] + $0 } ?? [value]
  }
}
