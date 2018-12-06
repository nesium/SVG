//
//  ImageRenderer.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import CoreGraphics

public final class ImageRenderer: Renderer {
  public enum OutputSize {
    case original
    case fixed(CGSize, ContentMode)
    case scaled(CGFloat)
  }

  public typealias StyleOverride = (
    _ element: ElementType,
    _ id: String?,
    _ className: String?,
    _ proposedStyle: Style?
  ) -> Style?

  private let outputSize: OutputSize
  private let screenScale: CGFloat
  private let backgroundColor: CGColor?
  private let styleOverride: StyleOverride

  private var ctx: CGContext!
  private var styles = StyleStack()

  public private(set) var image: CGImage?

  init(
    outputSize: OutputSize = .original,
    screenScale: CGFloat = 1,
    backgroundColor: CGColor? = nil,
    styleOverride: StyleOverride? = nil
  ) {
    self.outputSize = outputSize
    self.screenScale = screenScale
    self.backgroundColor = backgroundColor
    self.styleOverride = styleOverride ?? { _, _, _, style in style }
  }

  // MARK: - Renderer Methods -

  public func parserDidBeginDocument(_ parser: Parser, viewBox: CGRect) {
    let offset: CGPoint
    let scale: CGPoint
    let size: CGSize

    let screenScaleTransform = CGAffineTransform(scaleX: self.screenScale, y: self.screenScale)
    let viewBox = viewBox.applying(screenScaleTransform)

    switch self.outputSize {
      case .original:
        offset = CGPoint(x: -viewBox.minX, y: -viewBox.minY)
        size = viewBox.size
        scale = CGPoint(x: 1, y: 1)

      case let .fixed(targetSize, contentMode):
        let effectiveTargetSize = targetSize.applying(screenScaleTransform)
        let bounds = ContentMode.boundsForElement(
          with: viewBox.size,
          in: effectiveTargetSize,
          with: contentMode
        )
        offset = CGPoint(x: bounds.minX - viewBox.minX, y: bounds.minY - viewBox.minY)
        size = effectiveTargetSize
        scale = CGPoint(x: bounds.width / viewBox.width, y: bounds.height / viewBox.height)

      case let .scaled(targetScale):
        offset = CGPoint(x: -viewBox.minX, y: -viewBox.minY)
        size = CGSize(width: viewBox.width * targetScale, height: viewBox.height * targetScale)
        scale = CGPoint(x: targetScale, y: targetScale)
    }

    let ctx = CGContext(
      data: nil,
      width: Int(size.width),
      height: Int(size.height),
      bitsPerComponent: 8,
      bytesPerRow: Int(size.width) * 4,
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
    )

    precondition(ctx != nil, "Could not create CGContext.")

    self.ctx = ctx!
    self.ctx.interpolationQuality = .high

    self.backgroundColor.map {
      self.ctx.setFillColor($0)
      self.ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }

    self.ctx.concatenate(
      CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        .translatedBy(x: offset.x, y: offset.y)
        .scaledBy(x: scale.x * self.screenScale, y: scale.y * self.screenScale)
    )
  }

  public func parserDidEndDocument(_ parser: Parser) {
    self.image = self.ctx.makeImage()
  }

  public func parserDidStartGroup(
    _ parser: Parser,
    id: String?,
    className: String?,
    transform: CGAffineTransform?,
    style: Style?
  ) {
    self.ctx.saveGState()
    transform.map(ctx.concatenate)
    self.styles.push(self.styleOverride(.group, id, className, style))
  }

  public func parserDidEndGroup(_ parser: Parser) {
    self.ctx.restoreGState()
    self.styles.pop()
  }

  public func parser(
    _ parser: Parser,
    didFindGraphicElement type: ElementType,
    id: String?,
    className: String?,
    path: CGPath,
    transform: CGAffineTransform?,
    style: Style?
  ) {
    self.ctx.saveGState()
    self.styles.push(style)

    defer {
      self.ctx.restoreGState()
      self.styles.pop()
    }

    transform.map(self.ctx.concatenate)

    self.styleOverride(.group, id, className, self.styles.current)
      .map { currentStyle in
        draw(path: path, in: self.ctx, style: currentStyle)
      }
  }
}
