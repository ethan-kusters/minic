//
//  LLVMValue+ARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMValue {
    var armRegister: ([ARMInstruction]?, ARMRegister) {
        switch(self) {
        case let .register(llvmVirtualRegister):
            return (nil, llvmVirtualRegister.armRegister)
        case let .literal(value):
            let targetReg = ARMRegister.virtual(LLVMVirtualRegister.newIntRegister())
            
            if let _ = Int16(exactly: value) {
                let movInstr = ARMInstruction.move(condCode: nil,
                                                          target: targetReg,
                                                          source: .constant(ARMImmediateValue(value)))
                
                return ([movInstr], targetReg)
            } else {
                let movBot = ARMInstruction.moveBottom(condCode: nil,
                                                       target: targetReg,
                                                       source: .literal(prefix: .lower16,
                                                                        immediate: ARMImmediateValue(value)))
                
                let movTop = ARMInstruction.moveTop(condCode: nil,
                                                    target: targetReg,
                                                    source: .literal(prefix: .upper16,
                                                                     immediate: ARMImmediateValue(value)))
                
                return ([movBot, movTop], targetReg)
            }
        case .null:
            let targetReg = ARMRegister.virtual(LLVMVirtualRegister.newIntRegister())
            let moveInstruction = ARMInstruction.move(condCode: nil,
                                                      target: targetReg,
                                                      source: .constant(0))
            return ([moveInstruction], targetReg)
        case .void:
            fatalError("Cannot convert `void` LLVM Values to ARM.")
        }
    }
}
