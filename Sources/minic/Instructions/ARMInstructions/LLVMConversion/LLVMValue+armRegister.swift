//
//  LLVMValue+ARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMValue {
    func getARMRegister(_ context: CodeGenerationContext) -> ([ARMInstruction]?, ARMRegister) {
        switch(self) {
        case let .register(llvmVirtualRegister):
            return (nil, context.getRegister(fromVirtualRegister: llvmVirtualRegister))
        case let .literal(value):
            let targetReg = context.newVirtualRegister()
            
            if let _ = Int16(exactly: value) {
                let movInstr = ARMInstruction.move(condCode: nil,
                                                          target: targetReg,
                                                          source: .constant(value.immediateValue)).logRegisterUses()
                
                return ([movInstr], targetReg)
            } else {
                let move32Instr = ARMInstructionMacros.getMoveLiteral32(target: targetReg,
                                                                        source: value.immediateValue)
                
                return (move32Instr, targetReg)
            }
        case .null:
            let targetReg = context.newVirtualRegister()
            let moveInstruction = ARMInstruction.move(condCode: nil,
                                                      target: targetReg,
                                                      source: .constant(ARMInstructionConstants.nullValue)).logRegisterUses()
            
            return ([moveInstruction], targetReg)
        case .void:
            fatalError("Cannot convert `void` LLVM Values to ARM.")
        }
    }
    
    func moveToRegister(_ context: CodeGenerationContext, target: ARMRegister) -> ([ARMInstruction]) {
        switch(self) {
        case let .register(llvmVirtualRegister):
            let sourceOp = context.getRegister(fromVirtualRegister: llvmVirtualRegister).flexibleOperand
            
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target,
                                               source: sourceOp).logRegisterUses()
            
            return [movInstr]
        case let .literal(value):
            if let _ = Int16(exactly: value) {
                let movInstr = ARMInstruction.move(condCode: nil,
                                                          target: target,
                                                          source: .constant(value.immediateValue)).logRegisterUses()
                
                return [movInstr]
            } else {
                let move32Instr = ARMInstructionMacros.getMoveLiteral32(target: target,
                                                                        source: value.immediateValue)
                
                return move32Instr
            }
        case .null:
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target,
                                               source: .constant(ARMInstructionConstants.nullValue)).logRegisterUses()
            
            return [movInstr]
        case .void:
            fatalError("Cannot convert `void` LLVM Values to ARM.")
        }
    }
}
