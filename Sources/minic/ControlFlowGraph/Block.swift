//
//  Block.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class Block {
    let label: String
    var instructions = [Instruction]()
    var predecessors = [Block]()
    var successors = [Block]()
    
    init(_ description: String) {
        self.label = Block.getLabel(description)
    }
    
    init(_ description: String, instructions: [Instruction]) {
        self.label = Block.getLabel(description)
        self.instructions = instructions
    }
    
    func addPredecessor(_ block: Block) {
        predecessors.append(block)
    }
    
    func addSuccesor(_ block: Block) {
        successors.append(block)
    }
    
    func addInstructions(_ newInstructions: [Instruction]) {
        instructions.append(contentsOf: newInstructions)
    }
    
    func addInstruction(_ newInstruction: Instruction) {
        instructions.append(newInstruction)
    }
}

extension Block {
    private static var labelIndex: Int = 0
    
    private static func getLabel(_ description: String) -> String {
        labelIndex += 1
        return "_L\(labelIndex)_\(description)".replacingOccurrences(of: " ", with: "_")
    }
}

extension Block: Equatable {
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.label == rhs.label
            && lhs.predecessors == rhs.predecessors
            && lhs.successors == rhs.successors
            && lhs.instructions == rhs.instructions
    }
}

extension Block: CustomStringConvertible {
    var description: String {
        label
    }
}
