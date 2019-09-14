//
//  UIBezierPath+SVG.swift
//  SVG
//
//  Created by Marc Bauer on 05.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

extension UIBezierPath {
  public static func svg_fromPath(string: String) -> UIBezierPath {
    return UIBezierPath(cgPath: CGPath.svg_fromPath(string: string))
  }
}

extension UIImage {
  public static func svg_from(
    data: Data,
    size: ImageRenderer.OutputSize = .original,
    scale: CGFloat = UIScreen.main.scale,
    backgroundColor: UIColor? = nil,
    styleOverride: ImageRenderer.StyleOverride? = nil
  ) -> UIImage? {
    let renderer = ImageRenderer(
      outputSize: size,
      screenScale: scale,
      backgroundColor: backgroundColor?.cgColor,
      styleOverride: styleOverride
    )

    do {
      try Parser(data: data, renderer: renderer).parse()
    } catch {
      return nil
    }
    return renderer.image.map { UIImage(cgImage: $0, scale: scale, orientation: .up) }
  }

  public static func svg_named(
    _ name: String,
    in bundle: Bundle = Bundle.main,
    size: ImageRenderer.OutputSize = .original,
    scale: CGFloat = UIScreen.main.scale,
    backgroundColor: UIColor? = nil,
    styleOverride: ImageRenderer.StyleOverride? = nil
  ) -> UIImage? {
    let name = name.suffix(4).lowercased() == ".svg"
      ? (name as NSString).deletingPathExtension
      : name

    guard
      let url = bundle.url(forResource: name, withExtension: "svg"),
      let data = try? Data(contentsOf: url) else {
      return nil
    }

    return UIImage.svg_from(
      data: data,
      size: size,
      scale: scale,
      backgroundColor: backgroundColor,
      styleOverride: styleOverride
    )
  }
}
#endif
