//
//  ARMInstructionBlock.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension InstructionBlock where InstructionType == ARMInstruction {
    convenience init(withLLVMInstructionBlock llvmInstructionBlock: InstructionBlock<LLVMInstruction>) {
        llvmInstructionBlock.deconstructSSA()
        self.init(label: llvmInstructionBlock.label,
                  sealed: llvmInstructionBlock.sealed,
                  instructions: llvmInstructionBlock.instructions.armInstructions)
    }
}
