//
//  ARMInstructionBlockArray+getBlockForLLVMBlock.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension Array where Element == InstructionBlock<ARMInstruction> {
    mutating func getBlock(forLLVMBlock llvmBlock: InstructionBlock<LLVMInstruction>,
                           withContext context: CodeGenerationContext) -> InstructionBlock<ARMInstruction> {
        guard let existingBlock = first(where: { $0.label == llvmBlock.label }) else {
            let newBlock = InstructionBlock(withLLVMInstructionBlock: llvmBlock, context: context)
            append(newBlock)
            return newBlock
        }
        
        return existingBlock
    }
}
