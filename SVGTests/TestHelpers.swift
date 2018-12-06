//
//  TestHelpers.swift
//  SVGTests
//
//  Created by Marc Bauer on 05.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import XCTest

@testable import SVG

func imageFromSVG(
  _ name: String,
  size: ImageRenderer.OutputSize = .original,
  screenScale: CGFloat = 1,
  backgroundColor: CGColor? = nil,
  styleOverride: ImageRenderer.StyleOverride? = nil
) -> UIImage {
  let data = try! Data(contentsOf: Bundle.testBundle.url(forSVG: name)!)
  let renderer = ImageRenderer(
    outputSize: size,
    screenScale: screenScale,
    backgroundColor: backgroundColor,
    styleOverride: styleOverride
  )

  do {
    try Parser(data: data, renderer: renderer).parse()
  } catch {
    XCTFail(error.localizedDescription)
    fatalError()
  }

  return UIImage(cgImage: renderer.image!, scale: UIScreen.main.scale, orientation: .up)
}

extension Bundle {
  static var testBundle: Bundle {
    return Bundle(for: GraphicElementTests.classForCoder())
  }

  func url(forSVG svg: String) -> URL? {
    return self.url(forResource: svg, withExtension: "svg")
  }
}
