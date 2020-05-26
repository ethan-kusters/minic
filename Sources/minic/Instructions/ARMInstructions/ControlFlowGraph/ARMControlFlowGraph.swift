//
//  ARMControlFlowGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

class ARMControlFlowGraph: ControlFlowGraph<ARMInstruction, ARMInstructionBlock> {
    let context: CodeGenerationContext
    
    init(withBlocks blocks: [ARMInstructionBlock], forFunction function: Function, context: CodeGenerationContext) {
        self.context = context
        super.init(blocks: blocks, function: function)
        
        let functionPrologue = ARMInstructionMacros.getFunctionPrologue(context, registersUsed: [], valuesOnStack: 0)
        let functionEpilogue = ARMInstructionMacros.getFunctionEpilogue(context, registersUsed: [], valuesOnStack: 0)
        
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
