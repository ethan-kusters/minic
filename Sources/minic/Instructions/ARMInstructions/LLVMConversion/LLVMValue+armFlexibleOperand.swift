//
//  LLVMValue+armFlexibleOperand.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMValue {
    var armFlexibleOperand: ([ARMInstruction]?, ARMFlexibleOperand) {
        switch(self) {
        case let .register(virtualRegister):
            return (nil, .register(virtualRegister.armRegister))
        case let .literal(value):
            if let _ = Int16(exactly: value) {
                return (nil, .constant(value.immediateValue))
            }
            
            let destReg = ARMRegister.virtual(.newIntRegister())
            let movBot = ARMInstruction.moveBottom(condCode: nil,
                                                   target: destReg,
                                                   source: .literal(prefix: .lower16,
                                                                    immediate: value.immediateValue))
            
            let movTop = ARMInstruction.moveTop(condCode: nil,
                                                target: destReg,
                                                source: .literal(prefix: .upper16,
                                                                 immediate: value.immediateValue))
            
            return ([movBot, movTop], .register(destReg))
        case .null:
            return (nil, .constant(0))
        case .void:
            fatalError("Cannot convert `void` LLVM Values to ARM.")
        }
    }
}
