//
//  InstructionBlock.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class InstructionBlock<InstructionType: InstructionProtocol> {
    let uuid = UUID()
    let label: String
    var instructions: [InstructionType]
    var predecessors: [InstructionBlock<InstructionType>]
    var successors: [InstructionBlock<InstructionType>]
    var identifierMapping: [LLVMIdentifier : LLVMValue]
    var sealed: Bool
    
    init(label: String,
         sealed: Bool,
         instructions: [InstructionType] = [InstructionType](),
         predecessors: [InstructionBlock<InstructionType>] = [InstructionBlock<InstructionType>](),
         successors: [InstructionBlock<InstructionType>] = [InstructionBlock<InstructionType>](),
         identifierMapping: [LLVMIdentifier : LLVMValue] = [LLVMIdentifier : LLVMValue]()) {
        self.label = label
        self.sealed = sealed
        self.instructions = instructions
        self.predecessors = predecessors
        self.successors = successors
        self.identifierMapping = identifierMapping
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
    
    func insertInstruction(_ newInstruction: InstructionType, at index: Int) {
        instructions.insert(newInstruction, at: index)
    }
    
    func replaceInstruction(_ currentInstruction: InstructionType, with newInstruction: InstructionType) {
        if let index = instructions.firstIndex(of: currentInstruction) {
            instructions[index] = newInstruction
            
            if let llvmInstruction = currentInstruction as? LLVMInstruction {
                llvmInstruction.removeRegisterUses()
            }
        }
    }
}
