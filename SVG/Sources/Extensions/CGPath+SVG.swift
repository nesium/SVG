//
//  CGPath+SVG.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import CoreGraphics

extension CGPath {
  static func svg_fromRect(attributes: [String: String]) -> CGPath? {
    return zip(
      attributes["width"].flatMap(CGFloat.svg_from),
      attributes["height"].flatMap(CGFloat.svg_from)
    )
      .map { (width: CGFloat, height: CGFloat) in
        let rect = CGRect(
          x: attributes["x"].flatMap(CGFloat.svg_from) ?? 0,
          y: attributes["y"].flatMap(CGFloat.svg_from) ?? 0,
          width: width,
          height: height
        )

        guard !rect.isEmpty else {
          return CGMutablePath()
        }

        let rx = attributes["rx"].flatMap(CGFloat.svg_from)
        let ry = attributes["ry"].flatMap(CGFloat.svg_from)

        guard rx != nil || ry != nil else {
          return CGPath(rect: rect, transform: nil)
        }

        let path = CGMutablePath()
        path.addRoundedRect(
          in: rect,
          cornerWidth: min((rx ?? ry ?? 0), rect.width / 2),
          cornerHeight: min((ry ?? rx ?? 0), rect.height / 2)
        )
        return path
      }
  }

  static func svg_fromCircle(attributes: [String: String]) -> CGPath? {
    return attributes["r"].flatMap(CGFloat.svg_from)
      .map { (r: CGFloat) in
        let cx = attributes["cx"].flatMap(CGFloat.svg_from) ?? 0
        let cy = attributes["cy"].flatMap(CGFloat.svg_from) ?? 0

        return CGPath(
          ellipseIn: CGRect(
            x: cx - r,
            y: cy - r,
            width: r * 2,
            height: r * 2
          ),
          transform: nil
        )
      }
  }

  static func svg_fromEllipse(attributes: [String: String]) -> CGPath? {
    return zip(
      attributes["rx"].flatMap(CGFloat.svg_from),
      attributes["ry"].flatMap(CGFloat.svg_from)
    )
      .map { (rx: CGFloat, ry: CGFloat) in
        guard rx > 0 && ry > 0 else {
          return CGMutablePath()
        }

        let cx = attributes["cx"].flatMap(CGFloat.svg_from) ?? 0
        let cy = attributes["cy"].flatMap(CGFloat.svg_from) ?? 0

        return CGPath(
          ellipseIn: CGRect(
            x: cx - rx,
            y: cy - ry,
            width: rx * 2,
            height: ry * 2
          ),
          transform: nil
        )
      }
  }

  static func svg_fromLine(attributes: [String: String]) -> CGPath? {
    let x1 = attributes["x1"].flatMap(CGFloat.svg_from) ?? 0
    let y1 = attributes["y1"].flatMap(CGFloat.svg_from) ?? 0

    let x2 = attributes["x2"].flatMap(CGFloat.svg_from) ?? 0
    let y2 = attributes["y2"].flatMap(CGFloat.svg_from) ?? 0

    let p1 = CGPoint(x: x1, y: y1)
    let p2 = CGPoint(x: x2, y: y2)

    guard p1 != p2 else {
      return CGMutablePath()
    }

    let path = CGMutablePath()
    path.move(to: p1)
    path.addLine(to: p2)
    return path
  }

  static func svg_fromPolygon(attributes: [String: String]) -> CGPath? {
    guard let pointsString = attributes["points"], !pointsString.isEmpty else {
      return CGMutablePath()
    }

    let scanner = Scanner.svg_scanner(string: pointsString)

    return scanner.scanCGPoint().map {
      let path = CGMutablePath()
      path.move(to: $0)

      while let point = scanner.scanCGPoint() {
        path.addLine(to: point)
      }

      path.closeSubpath()
      return path
    }
  }

  static func svg_fromPolyline(attributes: [String: String]) -> CGPath? {
    guard let pointsString = attributes["points"], !pointsString.isEmpty else {
      return CGMutablePath()
    }

    let scanner = Scanner.svg_scanner(string: pointsString)

    return scanner.scanCGPoint().map {
      let path = CGMutablePath()
      path.move(to: $0)

      while let point = scanner.scanCGPoint() {
        path.addLine(to: point)
      }

      return path
    }
  }

  static func svg_fromPath(attributes: [String: String]) -> CGPath? {
    return attributes["d"].flatMap(CGPath.svg_fromPath)
  }

  static func svg_fromPath(string d: String) -> CGPath {
    let scanner = Scanner.svg_scanner(string: d)
    let instructionSet = CharacterSet(charactersIn: "ACHLMQSTVZachlmqstvz")

    let path = CGMutablePath()
    var lastInstruction: Character?
    var curveHistory = CurveHistory()

    var isFirstInstruction = true

    while let instructions = scanner.scanCharacters(from: instructionSet) {
      for instruction in instructions {
        if isFirstInstruction, instruction != "M" {
          // Prevents 'CGPathGetCurrentPoint: no current point.' messages
          path.move(to: .zero)
        }
        isFirstInstruction = false

        switch instruction {
          case "M":
            path.svg_moveTo(scanner, type: .absolute)
          case "m":
            path.svg_moveTo(scanner, type: .relative)

          case "Z", "z":
            path.svg_closePath()

          case "L":
            path.svg_lineTo(scanner, type: .absolute)
          case "l":
            path.svg_lineTo(scanner, type: .relative)

          case "H":
            path.svg_horizontalLineTo(scanner, type: .absolute)
          case "h":
            path.svg_horizontalLineTo(scanner, type: .relative)

          case "V":
            path.svg_verticalLineTo(scanner, type: .absolute)
          case "v":
            path.svg_verticalLineTo(scanner, type: .relative)

          case "C":
            path.svg_cubicBezierCurveTo(scanner, type: .absolute, history: &curveHistory)
          case "c":
            path.svg_cubicBezierCurveTo(scanner, type: .relative, history: &curveHistory)

          case "S":
            path.svg_smoothCubicBezierCurveTo(
              scanner,
              type: .absolute,
              currentInstruction: "S",
              lastInstruction: lastInstruction,
              history: &curveHistory
            )
          case "s":
            path.svg_smoothCubicBezierCurveTo(
              scanner,
              type: .relative,
              currentInstruction: "s",
              lastInstruction: lastInstruction,
              history: &curveHistory
            )

          case "Q":
            path.svg_quadraticBezierCurveTo(scanner, type: .absolute, history: &curveHistory)
          case "q":
            path.svg_quadraticBezierCurveTo(scanner, type: .relative, history: &curveHistory)

          case "T":
            path.svg_smoothQuadraticBezierCurveTo(
              scanner,
              type: .absolute,
              lastInstruction: lastInstruction!,
              history: &curveHistory
            )
          case "t":
            path.svg_smoothQuadraticBezierCurveTo(
              scanner,
              type: .relative,
              lastInstruction: lastInstruction!,
              history: &curveHistory
            )

          case "A":
            path.svg_addingEllipticalArcTo(scanner, type: .absolute)
          case "a":
            path.svg_addingEllipticalArcTo(scanner, type: .relative)

          default:
            print("Found unsupported path instruction \(instruction)")
            break
        }

        lastInstruction = instruction
      }
    }

    return path
  }
}
