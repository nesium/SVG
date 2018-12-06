//
//  CGMutablePath+SVG.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import CoreGraphics

struct CurveHistory {
  var controlPoint: CGPoint = .zero
}

enum PathType {
  case absolute
  case relative
}

extension CGMutablePath {
  func svg_moveTo(_ scanner: Scanner, type: PathType) {
    scanner.scanCGPoint().map {
      self.move(to: self.svg_convert(point: $0, to: type))
      self.svg_lineTo(scanner, type: type)
    }
  }

  func svg_closePath() {
    self.closeSubpath()
  }

  func svg_lineTo(_ scanner: Scanner, type: PathType) {
    scanner.scanCGPoint().map {
      self.addLine(to: self.svg_convert(point: $0, to: type))
      // Test if instruction is a polyline
      self.svg_lineTo(scanner, type: type)
    }
  }

  func svg_horizontalLineTo(_ scanner: Scanner, type: PathType) {
    scanner.scanCGFloat().map {
      let p = type == .absolute
        ? CGPoint(x: $0, y: self.currentPoint.y)
        : CGPoint(x: self.currentPoint.x + $0, y: self.currentPoint.y)
      self.addLine(to: p)
      self.svg_horizontalLineTo(scanner, type: type)
    }
  }

  func svg_verticalLineTo(_ scanner: Scanner, type: PathType) {
    scanner.scanCGFloat().map {
      let p = type == .absolute
        ? CGPoint(x: self.currentPoint.x, y: $0)
        : CGPoint(x: self.currentPoint.x, y: self.currentPoint.y + $0)
      self.addLine(to: p)
      self.svg_verticalLineTo(scanner, type: type)
    }
  }

  func svg_cubicBezierCurveTo(
    _ scanner: Scanner,
    type: PathType,
    history: inout CurveHistory
  ) {
    zip(
      scanner.scanCGPoint(),
      scanner.scanCGPoint(),
      scanner.scanCGPoint()
    )
      .map { c1, c2, p in
        history.controlPoint = self.svg_convert(point: c2, to: type)

        self.addCurve(
          to: self.svg_convert(point: p, to: type),
          control1: self.svg_convert(point: c1, to: type),
          control2: history.controlPoint
        )

        // Test if instruction is a polybézier
        self.svg_cubicBezierCurveTo(scanner, type: type, history: &history)
      }
  }

  func svg_smoothCubicBezierCurveTo(
    _ scanner: Scanner,
    type: PathType,
    currentInstruction: Character,
    lastInstruction: Character?,
    history: inout CurveHistory
  ) {
    zip(
      scanner.scanCGPoint(),
      scanner.scanCGPoint()
    )
      .map { c2, p in
        var c1 = self.currentPoint

        if let lastInstruction = lastInstruction {
          switch lastInstruction {
            case "C", "c", "S", "s":
              c1 = history.controlPoint.svg_reflecting(around: self.currentPoint)

            default:
              break
          }
        }

        history.controlPoint = self.svg_convert(point: c2, to: type)

        self.addCurve(
          to: self.svg_convert(point: p, to: type),
          control1: c1,
          control2: history.controlPoint
        )

        // Test if instruction is a polybézier
        self.svg_smoothCubicBezierCurveTo(
          scanner,
          type: type,
          currentInstruction: currentInstruction,
          lastInstruction: currentInstruction,
          history: &history
        )
      }
  }

  func svg_quadraticBezierCurveTo(
    _ scanner: Scanner,
    type: PathType,
    history: inout CurveHistory
  ) {
    zip(
      scanner.scanCGPoint(),
      scanner.scanCGPoint()
    )
      .map { c, p in
        history.controlPoint = self.svg_convert(point: c, to: type)
        self.addQuadCurve(
          to: self.svg_convert(point: p, to: type),
          control: history.controlPoint
        )

        // Test if instruction is a polybézier
        self.svg_quadraticBezierCurveTo(scanner, type: type, history: &history)
      }
  }

  func svg_smoothQuadraticBezierCurveTo(
    _ scanner: Scanner,
    type: PathType,
    lastInstruction: Character,
    history: inout CurveHistory
  ) {
    scanner.scanCGPoint()
      .map { p in
        var c = self.currentPoint

        switch lastInstruction {
          case "Q", "q", "T", "t":
            c = history.controlPoint.svg_reflecting(around: self.currentPoint)

          default:
            break
        }

        history.controlPoint = c

        self.addQuadCurve(to: self.svg_convert(point: p, to: type), control: c)

        // Test if instruction is a polybézier
        self.svg_smoothQuadraticBezierCurveTo(
          scanner,
          type: type,
          lastInstruction: lastInstruction,
          history: &history
        )
      }
  }

  func svg_addingEllipticalArcTo(_ scanner: Scanner, type: PathType) {
    guard
      var radii = scanner.scanCGPoint(),
      let xAxisRotation = scanner.scanCGFloat().map({ $0 * (CGFloat.pi / 180) }),
      let largeArcFlag = scanner.scanInt().map({ $0 == 1 }),
      let sweepFlag = scanner.scanInt().map({ $0 == 1 }),
      let endPoint = scanner.scanCGPoint().map({ self.svg_convert(point: $0, to: type) })
    else {
      return
    }

    // https://github.com/jmenter/JAMSVGImage/blob/286d4920e6d702a967b23ff644d06b6c5571550e/Classes/JAMSVGImage/Path%20and%20Parser/JAMStyledBezierPathFactory.m
    let currentPoint = CGPoint(
      x: cos(xAxisRotation) * (self.currentPoint.x - endPoint.x) / 2 +
        sin(xAxisRotation) * (self.currentPoint.y - endPoint.y) / 2,
      y: -sin(xAxisRotation) * (self.currentPoint.x - endPoint.x) / 2 +
        cos(xAxisRotation) * (self.currentPoint.y - endPoint.y) / 2
    )

    let radiiAdjustment = pow(currentPoint.x, 2) / pow(radii.x, 2)
      + pow(currentPoint.y, 2) / pow(radii.y, 2)
    radii.x *= (radiiAdjustment > 1) ? sqrt(radiiAdjustment) : 1
    radii.y *= (radiiAdjustment > 1) ? sqrt(radiiAdjustment) : 1

    var sweep = (largeArcFlag == sweepFlag ? -1 : 1) *
      sqrt(
        ((pow(radii.x, 2) * pow(radii.y, 2)) - (pow(radii.x, 2) * pow(currentPoint.y, 2)) -
        (pow(radii.y, 2) * pow(currentPoint.x, 2))) / (pow(radii.x, 2) * pow(currentPoint.y, 2) +
        pow(radii.y, 2) * pow(currentPoint.x, 2))
      )

    sweep = (sweep != sweep) ? 0 : sweep

    let preCenterPoint = CGPoint(
      x: sweep * radii.x * currentPoint.y / radii.y,
      y: sweep * -radii.y * currentPoint.x / radii.x
    )

    let centerPoint = CGPoint(
      x: (self.currentPoint.x + endPoint.x) / 2 +
        cos(xAxisRotation) * preCenterPoint.x - sin(xAxisRotation) * preCenterPoint.y,
      y: (self.currentPoint.y + endPoint.y) / 2 +
        sin(xAxisRotation) * preCenterPoint.x + cos(xAxisRotation) * preCenterPoint.y
    )

    let startAngle = CGPoint(x: 1, y: 0).svg_angle(to:
      CGPoint(
        x: (currentPoint.x - preCenterPoint.x) / radii.x,
        y: (currentPoint.y - preCenterPoint.y) / radii.y
      )
    )

    let deltaU = CGPoint(
      x: (currentPoint.x - preCenterPoint.x) / radii.x,
      y: (currentPoint.y - preCenterPoint.y) / radii.y
    )
    let deltaV = CGPoint(
      x: (-currentPoint.x - preCenterPoint.x) / radii.x,
      y: (-currentPoint.y - preCenterPoint.y) / radii.y
    )

    var angleDelta = (deltaU.x * deltaV.y < deltaU.y * deltaV.x ? -1 : 1) *
      acos(deltaU.svg_ratio(to: deltaV))

    angleDelta = (deltaU.svg_ratio(to: deltaV) <= -1)
      ? CGFloat.pi
      : (deltaU.svg_ratio(to: deltaV) >= 1) ? 0 : angleDelta

    let radius = max(radii.x, radii.y)
    let scale = (radii.x > radii.y)
      ? CGPoint(x: 1, y: radii.y / radii.x)
      : CGPoint(x: radii.x / radii.y, y: 1)

    let transform = CGAffineTransform(translationX: centerPoint.x, y: centerPoint.y)
      .rotated(by: xAxisRotation)
      .scaledBy(x: scale.x, y: scale.y)

    self.addArc(
      center: .zero,
      radius: radius,
      startAngle: startAngle,
      endAngle: startAngle + angleDelta,
      clockwise: !sweepFlag,
      transform: transform
    )
  }

  func svg_convert(point p: CGPoint, to type: PathType) -> CGPoint {
    switch type {
      case .absolute:
        return p

      case .relative:
        return CGPoint(x: self.currentPoint.x + p.x, y: self.currentPoint.y + p.y)
    }
  }
}
