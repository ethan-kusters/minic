//
//  InstructionBlock.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class InstructionBlock<InstructionType: InstructionProtocol> {
    let label: String
    let uuid = UUID()
    var instructions = [InstructionType]()
    var predecessors = [InstructionBlock<InstructionType>]()
    var successors = [InstructionBlock<InstructionType>]()
    var identifierMapping = [LLVMIdentifier : LLVMValue]()
    var sealed = false
    
    init(label: String, sealed: Bool) {
        self.label = label
        self.sealed = sealed
    }
    
    func addPredecessor(_ block: InstructionBlock<InstructionType>) {
        predecessors.append(block)
    }
    
    func addSuccesor(_ block: InstructionBlock<InstructionType>) {
        successors.append(block)
    }
    
    func addInstructions(_ newInstructions: [InstructionType]) {
        instructions.append(contentsOf: newInstructions)
    }
    
    func addInstruction(_ newInstruction: InstructionType) {
        instructions.append(newInstruction)
    }
    
    func replaceInstruction(_ currentInstruction: InstructionType, with newInstruction: InstructionType) {
        if let index = instructions.firstIndex(of: currentInstruction) {
            instructions[index] = newInstruction
        }
    }
}


