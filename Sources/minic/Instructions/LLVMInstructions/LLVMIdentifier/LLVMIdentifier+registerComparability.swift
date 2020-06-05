//
//  LLVMIdentifier+registerComparability.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMIdentifier {
    static func == (lhs: LLVMIdentifier, rhs: LLVMVirtualRegister) -> Bool {
        guard case let .virtualRegister(lhsRegister) = lhs else { return false }
        return lhsRegister == rhs
    }
}
