//
//  LLVMValue+armFlexibleOperand.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMValue {
    var armFlexibleOperand: ARMFlexibleOperand {
        switch(self) {
        case let .register(virtualRegister):
            return .register(virtualRegister.armRegister)
        case let .literal(value):
            return .constant(value)
        default:
            fatalError("Cannot convert `null` or `void` LLVM Values to ARM.")
        }
    }
}
