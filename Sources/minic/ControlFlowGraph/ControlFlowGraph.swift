//
//  ControlFlowGraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//

import Foundation

class ControlFlowGraph<InstructionType: InstructionProtocol, BlockType: InstructionBlock>: ControlFlowGraphProtocol {
    var blocks: [BlockType]
    var function: Function
    
    init(blocks: [BlockType], function: Function) {
        self.blocks = blocks
        self.function = function
    }
    
    func link(_ predecessor: BlockType, _ successor: BlockType) {
        predecessor.addSuccesor(successor)
        successor.addPredecessor(predecessor)
    }
}
