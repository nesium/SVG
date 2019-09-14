//
//  CGAffineTransform+SVG.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import Foundation
import CoreGraphics

extension CGAffineTransform {
  static func svg_skewX(_ a: CGFloat) -> CGAffineTransform {
    return CGAffineTransform(a: 1, b: 0, c: tan(a * (CGFloat.pi / 180)), d: 1, tx: 0, ty: 0)
  }

  static func svg_skewY(_ a: CGFloat) -> CGAffineTransform {
    return CGAffineTransform(a: 1, b: tan(a * (CGFloat.pi / 180)), c: 0, d: 1, tx: 0, ty: 0)
  }

  static func svg_from(string: String) -> CGAffineTransform? {
    return CGAffineTransform.svg_transform(with: Scanner.svg_scanner(string: string))
  }

  private static func svg_transform(with scanner: Scanner) -> CGAffineTransform? {
    guard
      let type = scanner.scanUpTo(str: "("),
      scanner.scanLocation + 1 < scanner.string.count
    else {
      return nil
    }

    scanner.scanLocation += 1

    let transform: CGAffineTransform?

    switch type {
      case "translate":
        transform = scanner.scanCGFloat()
          .map { tx in
            CGAffineTransform(translationX: tx, y: scanner.scanCGFloat() ?? 0)
          }

      case "scale":
        transform = scanner.scanCGFloat()
          .map { sx in
            CGAffineTransform(scaleX: sx, y: scanner.scanCGFloat() ?? sx)
          }

      case "skewX":
        transform = scanner.scanCGFloat().map(CGAffineTransform.svg_skewX)

      case "skewY":
        transform = scanner.scanCGFloat().map(CGAffineTransform.svg_skewY)

      case "rotate":
        transform = scanner.scanCGFloat()
          .map { a in
            let radians = a * (CGFloat.pi / 180)

            return zip(
              scanner.scanCGFloat(),
              scanner.scanCGFloat()
            )
              .map {
                let p = CGPoint(x: $0, y: $1)
                return CGAffineTransform(translationX: p.x, y: p.y)
                  .rotated(by: radians)
                  .translatedBy(x: -p.x, y: -p.y)
              }
            ?? CGAffineTransform(rotationAngle: radians)
          }

        case "matrix":
          transform = zip(
            scanner.scanCGFloat(),
            scanner.scanCGFloat(),
            scanner.scanCGFloat(),
            scanner.scanCGFloat(),
            scanner.scanCGFloat(),
            scanner.scanCGFloat()
          ).flatMap { (a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat, tx: CGFloat, ty: CGFloat) in
            CGAffineTransform(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
          }

      default:
        print("Found unsupported transform \(type)")
        transform = nil
    }

    return transform.map { t in
      _ = scanner.scanUpTo(str: ")")
      if !scanner.isAtEnd {
        scanner.scanLocation += 1
      }

      return CGAffineTransform.svg_transform(with: scanner).map {
        $0.concatenating(t)
      } ?? t
    }
  }
}
