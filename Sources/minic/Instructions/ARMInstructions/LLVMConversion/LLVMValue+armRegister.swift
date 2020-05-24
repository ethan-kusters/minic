//
//  LLVMValue+ARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMValue {
    var armRegister: (ARMInstruction?, ARMRegister) {
        switch(self) {
        case let .register(llvmVirtualRegister):
            return (nil, llvmVirtualRegister.armRegister)
        case let .literal(value):
            let targetReg = ARMRegister.virtual(LLVMVirtualRegister.newIntRegister())
            let moveInstruction = ARMInstruction.move(condCode: nil,
                                                      target: targetReg,
                                                      source: .constant(value))
            
            return (moveInstruction, targetReg)
        default:
            fatalError("Cannot convert `null` or `void` LLVM Values to ARM.")
        }
    }
}
