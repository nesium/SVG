//
//  ContentMode.swift
//  SVG
//
//  Created by Marc Bauer on 04.12.18.
//  Copyright © 2018 Marc Bauer. All rights reserved.
//

import CoreGraphics

public enum ContentMode {
  case scaleToFill
  case scaleAspectFit
  case scaleAspectFill
  case center
  case top
  case bottom
  case left
  case right
  case topLeft
  case topRight
  case bottomLeft
  case bottomRight
}


extension ContentMode {
  public static func boundsForElement(
    with size: CGSize,
    in other: CGSize,
    with contentMode: ContentMode
  ) -> CGRect {
  switch contentMode {
    case .scaleToFill:
      return CGRect(origin: .zero, size: other)

    case .scaleAspectFit where size.width > size.height:
      return boundsForElement(
        with: CGSize(width: other.width, height: size.height / size.width * other.width),
        in: other,
        with: .center
      )

    case .scaleAspectFit:
      return boundsForElement(
        with: CGSize(width: size.width / size.height * other.height, height: other.height),
        in: other,
        with: .center
      )

    case .scaleAspectFill where size.width > size.height:
      return boundsForElement(
        with: CGSize(width: size.width / size.height * other.height, height: other.height),
        in: other,
        with: .center
      )

    case .scaleAspectFill:
      return boundsForElement(
        with: CGSize(width: other.width, height: size.height / size.width * other.width),
        in: other,
        with: .center
      )

    case .center:
      return CGRect(
        origin: CGPoint(
          x: (other.width - size.width) / 2,
          y: (other.height - size.height) / 2
        ),
        size: size
      )

    case .top:
      return CGRect(
        origin: CGPoint(
          x: (other.width - size.width) / 2,
          y: 0
        ),
        size: size
      )

    case .bottom:
      return CGRect(
        origin: CGPoint(
          x: (other.width - size.width) / 2,
          y: other.height - size.height
        ),
        size: size
      )

    case .left:
      return CGRect(
        origin: CGPoint(
          x: 0,
          y: (other.height - size.height) / 2
        ),
        size: size
      )

    case .right:
      return CGRect(
        origin: CGPoint(
          x: other.width - size.width,
          y: (other.height - size.height) / 2
        ),
        size: size
      )

    case .topLeft:
      return CGRect(
        origin: CGPoint(
          x: 0,
          y: 0
        ),
        size: size
      )

    case .topRight:
      return CGRect(
        origin: CGPoint(
          x: other.width - size.width,
          y: 0
        ),
        size: size
      )

    case .bottomLeft:
      return CGRect(
        origin: CGPoint(
          x: 0,
          y: other.height - size.height
        ),
        size: size
      )

    case .bottomRight:
      return CGRect(
        origin: CGPoint(
          x: other.width - size.width,
          y: other.height - size.height
        ),
        size: size
      )
    }
  }
}
