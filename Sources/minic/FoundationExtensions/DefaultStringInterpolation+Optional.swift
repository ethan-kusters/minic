//
//  DefaultStringInterpolation+Optional.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension DefaultStringInterpolation {
  mutating func appendInterpolation<T>(optional: T?) {
    if let wrappedValue = optional {
        appendInterpolation(wrappedValue)
    }
  }
}
