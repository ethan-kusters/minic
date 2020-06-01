//
//  LLVMValue+armFlexibleOperand.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMValue {
    func getFlexibleOperand(_ context: CodeGenerationContext) -> ([ARMInstruction]?, ARMFlexibleOperand) {
        switch(self) {
        case let .register(virtualRegister):
            return (nil, context.getRegister(fromVirtualRegister: virtualRegister).flexibleOperand)
        case let .literal(value):
            guard !ARMFlexibleOperand.canHoldValue(value) else {
                return (nil, .constant(value.immediateValue))
            }
            
            let destReg = context.newVirtualRegister()
            let movInstr = ARMInstructionMacros.getMoveLiteral32(context,
                                                                 target: destReg,
                                                                 source: value.immediateValue)
            return (movInstr, .register(destReg))
        case .null:
            return (nil, .constant(0))
        case .void:
            fatalError("Cannot convert `void` LLVM Values to ARM.")
        }
    }
}
