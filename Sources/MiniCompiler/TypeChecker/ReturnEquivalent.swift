//
//  File.swift
//  
//
//  Created by Ethan Kusters on 4/14/20.
//

import Foundation

enum ReturnEquivalent {
    case isReturnEquivalent
    case notReturnEquivalent
}

extension ReturnEquivalent {
    static func && (lhs: ReturnEquivalent, rhs: ReturnEquivalent) -> ReturnEquivalent {
        guard lhs == .isReturnEquivalent && rhs == .isReturnEquivalent else {
            return .notReturnEquivalent
        }

        return .isReturnEquivalent
    }
}
