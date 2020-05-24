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
    }
    
}
