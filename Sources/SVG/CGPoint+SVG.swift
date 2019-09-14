//
//  CGPoint+SVG.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import CoreGraphics

extension CGPoint {
  func svg_reflecting(around other: CGPoint) -> CGPoint {
    return CGPoint(x: other.x * 2 - self.x, y: other.y * 2 - self.y)
  }

  var svg_magnitude: CGFloat {
    return sqrt(pow(self.x, 2) + pow(self.y, 2))
  }

  func svg_ratio(to point: CGPoint) -> CGFloat {
    return (self.x * point.x + self.y * point.y) / (self.svg_magnitude * point.svg_magnitude)
  }

  func svg_angle(to point: CGPoint) -> CGFloat {
    return (self.x * point.y < self.y * point.x ? -1 : 1) * acos(self.svg_ratio(to: point))
  }
}

