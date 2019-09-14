//
//  StyleStack.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import CoreGraphics

final class StyleStack {
  private static let defaultStyle = Style(
    fillColor: CGColor(colorSpace: CGColor.svg_sharedColorspace, components: [0, 0, 0, 1])
  )

  private var styles = [Style]()

  var current: Style {
    return self.styles.last ?? StyleStack.defaultStyle
  }

  func push(_ style: Style?) {
    guard var mutableStyle = style else {
      self.styles.append(self.current)
      return
    }

    let currentStyle = self.current

    if mutableStyle.fillColor == nil {
      mutableStyle.fillColor = currentStyle.fillColor
    }
    if mutableStyle.fillRule == nil || mutableStyle.fillRule == .inherit {
      mutableStyle.fillRule = currentStyle.fillRule
    }
    if mutableStyle.strokeColor == nil {
      mutableStyle.strokeColor = currentStyle.strokeColor
    }
    if mutableStyle.strokeWidth == nil {
      mutableStyle.strokeWidth = currentStyle.strokeWidth
    }
    if mutableStyle.strokeDashArray == nil {
      mutableStyle.strokeDashArray = currentStyle.strokeDashArray
    }
    if mutableStyle.strokeLineCap == nil {
      mutableStyle.strokeLineCap = currentStyle.strokeLineCap
    }
    if mutableStyle.strokeLineJoin == nil {
      mutableStyle.strokeLineJoin = currentStyle.strokeLineJoin
    }

    self.styles.append(mutableStyle)
  }

  func pop() {
    _ = self.styles.popLast()
  }
}
