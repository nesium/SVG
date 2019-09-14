//
//  drawElement.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import CoreGraphics

func draw(path: CGPath, in ctx: CGContext, style: Style) {
  var fill = false
  var stroke = false
  let useEvenOddRule = style.fillRule == .evenOdd

  if let fillColor = style.fillColor {
    ctx.setFillColor(fillColor)
    fill = true
  }

  if let strokeColor = style.strokeColor {
    ctx.setStrokeColor(strokeColor)
    ctx.setLineWidth(style.strokeWidth ?? 1)
    style.strokeDashArray.map { ctx.setLineDash(phase: 0, lengths: $0) }
    style.strokeLineCap.map { ctx.setLineCap($0.cgLineCap) }
    style.strokeLineJoin.map { ctx.setLineJoin($0.cgLineJoin) }
    stroke = true
  }

  let drawingMode: CGPathDrawingMode

  switch (fill, stroke, useEvenOddRule) {
    case (false, false, _):
      return

    case (true, false, false):
      drawingMode = .fill

    case (true, false, true):
      drawingMode = .eoFill

    case (false, true, _):
      drawingMode = .stroke

    case (true, true, false):
      drawingMode = .fillStroke

    case (true, true, true):
      drawingMode = .eoFillStroke
  }

  ctx.addPath(path)
  ctx.drawPath(using: drawingMode)
}
