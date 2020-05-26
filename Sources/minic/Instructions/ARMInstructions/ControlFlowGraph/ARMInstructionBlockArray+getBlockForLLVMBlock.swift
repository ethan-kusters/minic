//
//  ARMInstructionBlockArray+getBlockForLLVMBlock.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension Array where Element == ARMInstructionBlock {
    mutating func getBlock(forLLVMBlock llvmBlock: LLVMInstructionBlock,
                           withContext context: CodeGenerationContext) -> ARMInstructionBlock {
        guard let existingBlock = first(where: { $0.label == llvmBlock.label }) else {
            let newBlock = ARMInstructionBlock(withLLVMInstructionBlock: llvmBlock, context: context)
            append(newBlock)
            return newBlock
        }
        
        return existingBlock
    }
}
