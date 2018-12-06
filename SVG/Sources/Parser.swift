//
//  Parser.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import Foundation
import CoreGraphics

public final class Parser: NSObject, XMLParserDelegate {
  private let parser: XMLParser
  private let renderer: Renderer

  private var inSVG = false
  private var error: Error?

  // MARK: - Initialization

  public convenience init(stream: InputStream, renderer: Renderer) {
    self.init(parser: XMLParser(stream: stream), renderer: renderer)
  }

  public convenience init(data: Data, renderer: Renderer) {
    self.init(parser: XMLParser(data: data), renderer: renderer)
  }

  private init(parser: XMLParser, renderer: Renderer) {
    self.parser = parser
    self.renderer = renderer

    super.init()

    self.parser.delegate = self
  }

  // MARK: - Public Methods -

  public func parse() throws {
    self.parser.parse()
    if let error = self.error {
      throw error
    }
  }

  // MARK: - XMLParserDelegate Methods -

  public func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes: [String: String] = [:]
  ) {
    switch elementName {
      case ElementType.path.rawValue:
        self.assertInSVG()
        self.parseGraphic(
          element: .path,
          attributes: attributes,
          parser: CGPath.svg_fromPath
        )

      case ElementType.group.rawValue:
        self.assertInSVG()
        self.renderer.parserDidStartGroup(
          self,
          id: attributes["id"],
          className: attributes["className"],
          transform: attributes["transform"].flatMap(CGAffineTransform.svg_from),
          style: Style(attributes: attributes)
        )

      case ElementType.polygon.rawValue:
        self.assertInSVG()
        self.parseGraphic(
          element: .polygon,
          attributes: attributes,
          parser: CGPath.svg_fromPolygon
        )

      case ElementType.polyline.rawValue:
        self.assertInSVG()
        self.parseGraphic(
          element: .polyline,
          attributes: attributes,
          parser: CGPath.svg_fromPolyline
        )

      case ElementType.line.rawValue:
        self.assertInSVG()
        self.parseGraphic(
          element: .line,
          attributes: attributes,
          parser: CGPath.svg_fromLine
        )

      case ElementType.rect.rawValue:
        self.assertInSVG()
        self.parseGraphic(
          element: .rect,
          attributes: attributes,
          parser: CGPath.svg_fromRect
        )

      case ElementType.ellipse.rawValue:
        self.assertInSVG()
        self.parseGraphic(
          element: .ellipse,
          attributes: attributes,
          parser: CGPath.svg_fromEllipse
        )

      case ElementType.circle.rawValue:
        self.assertInSVG()
        self.parseGraphic(
          element: .circle,
          attributes: attributes,
          parser: CGPath.svg_fromCircle
        )

      case "svg":
        guard let viewBox = attributes["viewBox"].flatMap({
          Scanner.svg_scanner(string: $0).scanCGRect()
        }) else {
          return self.fail("Missing viewBox in svg.")
        }
        self.inSVG = true
        self.renderer.parserDidBeginDocument(self, viewBox: viewBox)

      default:
        break
    }
  }

  public func parser(
    _ parser: XMLParser,
    didEndElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?
  ) {
    switch elementName {
      case "g":
        self.renderer.parserDidEndGroup(self)

      case "svg":
        self.renderer.parserDidEndDocument(self)

      default:
        break
    }
  }

  public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    self.error = parseError
    self.parser.abortParsing()
  }

  // MARK: - Private Methods -

  private func parseGraphic(
    element: ElementType,
    attributes: [String: String],
    parser: ([String: String]) -> CGPath?
  ) {
    guard let path = parser(attributes) else {
      return self.fail("Invalid attributes in \(element.rawValue).")
    }

    self.renderer.parser(
      self,
      didFindGraphicElement: element,
      id: attributes["id"],
      className: attributes["className"],
      path: path,
      transform: attributes["transform"].flatMap(CGAffineTransform.svg_from),
      style: Style(attributes: attributes)
    )
  }

  private func fail(_ message: String) {
    self.error = NSError(
      domain: "SVG",
      code: 1,
      userInfo: [NSLocalizedDescriptionKey: "Error in line \(parser.lineNumber): \(message)"]
    )
    self.parser.abortParsing()
  }

  private func assertInSVG() {
    if !self.inSVG {
      self.fail("Malformed file. Missing svg element.")
    }
  }
}
