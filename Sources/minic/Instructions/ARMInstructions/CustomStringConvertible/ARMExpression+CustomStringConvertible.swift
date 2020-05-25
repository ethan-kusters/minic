//
//  ARMExpression+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMExpression: CustomStringConvertible {
    var description: String {
        switch(self) {
        case let .literal(prefix, immediate):
            return "#\(optional: prefix)\(immediate.value)"
        case let .symbol(prefix, symbol):
            return "#\(optional: prefix)\(symbol)"
        }
    }
}
