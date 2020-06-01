//
//  LLVMControlFlowGraph+removeUselessInstructions.swift
//  minic
//
//  Created by Ethan Kusters on 6/1/20.
//

import Foundation

extension LLVMControlFlowGraph {
    func removeUselessInstructions() {
        guard ssaEnabled else { return }
        
        while let uselessInstruction = blocks.firstUselessInstruction {
            let block = uselessInstruction.block
            block.removeInstruction(uselessInstruction)
        }
    }
}
