//
//  LLVMValue+registerComparability.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMValue {
    static func == (lhs: LLVMValue, rhs: LLVMVirtualRegister) -> Bool {
        guard case let .register(lhsRegister) = lhs else { return false }
        return lhsRegister == rhs
    }
    
    static func != (lhs: LLVMValue, rhs: LLVMVirtualRegister) -> Bool {
        return !(lhs == rhs)
    }
}
