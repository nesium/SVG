//
//  ZipOptional.swift
//  SVG
//
//  Created by Marc Bauer on 03.12.18.
//

import Foundation

func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
  guard let a = a, let b = b else {
    return nil
  }
  return (a, b)
}

func zip<A, B, C>(_ a: A?, _ b: B?, _ c: C?) -> (A, B, C)? {
  return zip(zip(a, b), c).map { ($0.0, $0.1, $1) }
}

func zip<A, B, C, D>(_ a: A?, _ b: B?, _ c: C?, _ d: D?) -> (A, B, C, D)? {
  return zip(zip(a, b), c, d).map { ($0.0, $0.1, $1, $2) }
}

func zip<A, B, C, D, E>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?) -> (A, B, C, D, E)? {
  return zip(zip(a, b), c, d, e).map { ($0.0, $0.1, $1, $2, $3) }
}

func zip<A, B, C, D, E, F>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?,
  _ e: E?,
  _ f: F?
) -> (A, B, C, D, E, F)? {
  return zip(zip(a, b), c, d, e, f).map { ($0.0, $0.1, $1, $2, $3, $4) }
}
