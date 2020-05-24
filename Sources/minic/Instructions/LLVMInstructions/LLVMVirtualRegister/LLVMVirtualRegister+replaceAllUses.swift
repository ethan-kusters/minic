//
//  LLVMVirtualRegister+replaceAllUses.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension LLVMVirtualRegister {
    func replaceAllUses(withValue value: LLVMValue) {
        uses.forEach { instruction in
            let newInstruction = instruction.replacingRegister(self, with: value).logRegisterUses()
            instruction.block.replaceInstruction(instruction, with: newInstruction)
        }
        
        removeAllUses()
    }
}
