//
//  ReturnEquivalent.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/14/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
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
