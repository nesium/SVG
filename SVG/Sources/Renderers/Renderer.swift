//
//  Renderer.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import CoreGraphics

public protocol Renderer {
  func parserDidBeginDocument(_ parser: Parser, viewBox: CGRect)
  func parserDidEndDocument(_ parser: Parser)

  func parserDidStartGroup(
    _ parser: Parser,
    id: String?,
    className: String?,
    transform: CGAffineTransform?,
    style: Style?
  )
  func parserDidEndGroup(_ parser: Parser)

  func parser(
    _ parser: Parser,
    didFindGraphicElement type: ElementType,
    id: String?,
    className: String?,
    path: CGPath,
    transform: CGAffineTransform?,
    style: Style?
  )
}
