//
//  LLVMInstructionBlockArray+firstUselessInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 6/1/20.
//

import Foundation

extension Collection where Element == LLVMInstructionBlock {
    var firstUselessInstruction: LLVMInstruction? {
        for block in self {
            if let uselessInstruction = block.firstUselessInstruction {
                return uselessInstruction
            }
        }
        
        return nil
    }
}
