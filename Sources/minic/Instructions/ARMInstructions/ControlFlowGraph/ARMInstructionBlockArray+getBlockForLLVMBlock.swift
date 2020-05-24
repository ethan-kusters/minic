//
//  ARMInstructionBlockArray+getBlockForLLVMBlock.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension Array where Element == InstructionBlock<ARMInstruction> {
    mutating func getBlock(forLLVMBlock llvmBlock: InstructionBlock<LLVMInstruction>) -> InstructionBlock<ARMInstruction> {
        guard let existingBlock = first(where: { $0.label == llvmBlock.label }) else {
            let newBlock = InstructionBlock(withLLVMInstructionBlock: llvmBlock)
            append(newBlock)
            return newBlock
        }
        
        return existingBlock
    }
}
