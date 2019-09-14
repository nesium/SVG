//
//  Style.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import Foundation
import CoreGraphics

public enum FillRule: String {
  case nonZero = "nonzero"
  case evenOdd = "evenodd"
  case inherit = "inherit"
}

public enum LineCap: String {
  case butt
  case round
  case square

  var cgLineCap: CGLineCap {
    switch self {
      case .butt:
        return CGLineCap.butt
      case .round:
        return CGLineCap.round
      case .square:
        return CGLineCap.square
    }
  }
}

public enum LineJoin: String {
  case miter
  case round
  case bevel

  var cgLineJoin: CGLineJoin {
    switch self {
      case .miter:
        return CGLineJoin.miter
      case .round:
        return CGLineJoin.round
      case .bevel:
        return CGLineJoin.bevel
    }
  }
}

public struct Style {
  public var fillColor: CGColor?
  public var fillRule: FillRule?
  public var strokeColor: CGColor?
  public var strokeWidth: CGFloat?
  public var strokeDashArray: [CGFloat]?
  public var strokeLineCap: LineCap?
  public var strokeLineJoin: LineJoin?

  init?(attributes: [String: String]) {
    self.fillColor = attributes["fill"].flatMap {
      let fillOpacity = attributes["fill-opacity"].flatMap(CGFloat.svg_from)
      return CGColor.svg_from(string: $0, opacity: fillOpacity ?? 1)
    }

    self.fillRule = attributes["fill-rule"].flatMap(FillRule.init)

    self.strokeColor = attributes["stroke"].flatMap {
      let strokeOpacity = attributes["stroke-opacity"].flatMap(CGFloat.svg_from)
      return CGColor.svg_from(string: $0, opacity: strokeOpacity ?? 1)
    }

    self.strokeWidth = attributes["stroke-width"].flatMap(CGFloat.svg_from)

    self.strokeDashArray = attributes["stroke-dasharray"].flatMap {
      Scanner.svg_scanner(string: $0).scanCGFloatArray()
    }

    self.strokeLineCap = attributes["stroke-linecap"].flatMap(LineCap.init)
    self.strokeLineJoin = attributes["stroke-linejoin"].flatMap(LineJoin.init)

    if
      self.fillColor == nil,
      self.fillRule == nil,
      self.strokeColor == nil,
      self.strokeWidth == nil,
      self.strokeDashArray == nil,
      self.strokeLineCap == nil
    {
      return nil
    }
  }

  public init(
    fillColor: CGColor? = nil,
    fillRule: FillRule? = nil,
    strokeColor: CGColor? = nil,
    strokeWidth: CGFloat? = nil,
    strokeDashArray: [CGFloat]? = nil,
    strokeLineCap: LineCap? = nil,
    strokeLineJoin: LineJoin? = nil
  ) {
    self.fillColor = fillColor
    self.fillRule = fillRule
    self.strokeColor = strokeColor
    self.strokeWidth = strokeWidth
    self.strokeDashArray = strokeDashArray
    self.strokeLineCap = strokeLineCap
    self.strokeLineJoin = strokeLineJoin
  }
}
