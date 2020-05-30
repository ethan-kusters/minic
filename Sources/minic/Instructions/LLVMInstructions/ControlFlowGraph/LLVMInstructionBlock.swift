//
//  LLVMInstructionBlock.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

final class LLVMInstructionBlock: InstructionBlock {
    typealias InstructionType = LLVMInstruction
    
    let uuid = UUID()
    let label: String
    
    var instructions = [InstructionType]()
    var predecessors = Set<LLVMInstructionBlock>()
    var successors = Set<LLVMInstructionBlock>()
    
    var identifierMapping = [LLVMIdentifier : LLVMValue]()
    var sealed: Bool
    
    var llvmIdentifier: LLVMIdentifier {
        .label(label)
    }
    
    var finalBranchIndex: Int? {
        instructions.lastIndex(where: { instruction in
            if case .unconditionalBranch = instruction {
                return true
            } else if case .conditionalBranch = instruction {
                return true
            }
            
            return false
        })
    }
    
    init(_ description: String, sealed: Bool = true) {
        self.label = LLVMInstructionBlock.getUniqueLabel(description)
        self.sealed = sealed
    }
    
    func addPredecessor(_ block: LLVMInstructionBlock) {
        predecessors.insert(block)
    }
    
    func addSuccesor(_ block: LLVMInstructionBlock) {
        successors.insert(block)
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
            currentInstruction.removeRegisterUses()
        }
    }
    
    func removeInstruction(_ instruction: InstructionType) {
        if let index = instructions.firstIndex(of: instruction) {
            instruction.removeRegisterUses()
            instructions.remove(at: index)
        }
    }
}
