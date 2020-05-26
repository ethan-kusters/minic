//
//  ARMControlFlowGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

class ARMControlFlowGraph: ControlFlowGraph {
    typealias instructionType = ARMInstruction
    
    var blocks: [InstructionBlock<ARMInstruction>]
    let function: Function
    let context: TypeContext
    
    init(withBlocks blocks: [InstructionBlock<ARMInstruction>], forFunction function: Function, context: TypeContext) {
        self.blocks = blocks
        self.function = function
        self.context = context
        
        let functionPrologue = ARMInstructionMacros.getFunctionPrologue(registersUsed: [], valuesOnStack: 0)
        let functionEpilogue = ARMInstructionMacros.getFunctionEpilogue(registersUsed: [], valuesOnStack: 0)
        
        self.blocks.first?.instructions.insert(contentsOf: functionPrologue, at: 0)
        self.blocks.last?.instructions.append(contentsOf: functionEpilogue)
    }
    
    var instructions: [ARMInstruction] {
        [
            ARMInstructionMacros.getFunctionHeader(function.name),
            blocks.flatMap { block in
                [
                    [ARMInstruction.label(symbol: block.label)],
                    block.instructions
                ].flatten()
            },
            ARMInstructionMacros.getFunctionFooter(function.name)
        ].flatten()
    }
    
}
