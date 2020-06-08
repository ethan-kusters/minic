//
//  ARMControlFlowGraph+insertInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 6/8/20.
//

import Foundation

extension ARMControlFlowGraph {
    func insertInstruction(_ newInstruction: ARMInstruction, after predecessorInstruction: ARMInstruction) {
        let block = blocks.first(where: { block in
            block.instructions.contains(predecessorInstruction)
        })!
        
        let instructionIndex = block.instructions.firstIndex(of: predecessorInstruction)!
        
        block.instructions.insert(newInstruction, at: instructionIndex + 1)
    }
    
    func insertInstruction(_ newInstruction: ARMInstruction, before successorInstruction: ARMInstruction) {
        let block = blocks.first(where: { block in
            block.instructions.contains(successorInstruction)
        })!
        
        let instructionIndex = block.instructions.firstIndex(of: successorInstruction)!
        
        block.instructions.insert(newInstruction, at: instructionIndex)
    }
}
