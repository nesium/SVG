//
//  CGFloat+SVG.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import CoreGraphics

extension CGFloat {
  static func svg_from(string: String) -> CGFloat? {
    return Float(string).map { CGFloat($0) }
  }
}
