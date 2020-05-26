//
//  InstructionBlock.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

protocol InstructionBlock: Hashable {
    associatedtype InstructionType: InstructionProtocol
    
    var uuid: UUID { get }
    var label: String { get }
    var instructions: [InstructionType] { get set }
    var predecessors: [Self] { get set }
    var successors: [Self] { get set }
//    var identifierMapping: [LLVMIdentifier : LLVMValue]
//    var sealed: Bool
    
//    init(label: String,
//         sealed: Bool,
//         instructions: [InstructionType] = [InstructionType](),
//         predecessors: [InstructionBlock<InstructionType>] = [InstructionBlock<InstructionType>](),
//         successors: [InstructionBlock<InstructionType>] = [InstructionBlock<InstructionType>](),
//         identifierMapping: [LLVMIdentifier : LLVMValue] = [LLVMIdentifier : LLVMValue]()) {
//        self.label = label
//        self.sealed = sealed
//        self.instructions = instructions
//        self.predecessors = predecessors
//        self.successors = successors
//        self.identifierMapping = identifierMapping
//    }
    
    func addPredecessor(_ block: Self)
    
    func addSuccesor(_ block: Self)
    
    func addInstructions(_ newInstructions: [InstructionType])
    
    func addInstruction(_ newInstruction: InstructionType)
    
    func insertInstruction(_ newInstruction: InstructionType, at index: Int)
    
    func replaceInstruction(_ currentInstruction: InstructionType, with newInstruction: InstructionType)
    
}

extension InstructionBlock {
    
    mutating func addPredecessor(_ block: Self) {
        predecessors.append(block)
    }
    
    mutating func addSuccesor(_ block: Self) {
        successors.append(block)
    }
    
    mutating func addInstructions(_ newInstructions: [InstructionType]) {
        instructions.append(contentsOf: newInstructions)
    }
    
    mutating func addInstruction(_ newInstruction: InstructionType) {
        instructions.append(newInstruction)
    }
    
    mutating func insertInstruction(_ newInstruction: InstructionType, at index: Int) {
        instructions.insert(newInstruction, at: index)
    }
    
    mutating func replaceInstruction(_ currentInstruction: InstructionType, with newInstruction: InstructionType) {
        if let index = instructions.firstIndex(of: currentInstruction) {
            instructions[index] = newInstruction
            
            if let llvmInstruction = currentInstruction as? LLVMInstruction {
                llvmInstruction.removeRegisterUses()
            }
        }
    }
}
