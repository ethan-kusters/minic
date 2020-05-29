//
//  ARMInstructionBlock.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

final class ARMInstructionBlock: InstructionBlock {
    typealias InstructionType = ARMInstruction

    let uuid = UUID()
    let label: String
    
    var instructions = [ARMInstruction]()
    var predecessors = [ARMInstructionBlock]()
    var successors = [ARMInstructionBlock]()
    
    // gen/kill sets:
    var generatedVariables = Set<ARMRegister>()
    var killedVariables = Set<ARMRegister>()
    var liveOutVariables = Set<ARMRegister>()
    
    init(withLLVMInstructionBlock llvmInstructionBlock: LLVMInstructionBlock, context: CodeGenerationContext) {
        llvmInstructionBlock.deconstructSSA()
        self.label = llvmInstructionBlock.label
        instructions = llvmInstructionBlock.instructions.getARMInstructions(withContext: context)
        computeGenKillSets()
    }
    
    func addPredecessor(_ block: ARMInstructionBlock) {
        predecessors.append(block)
    }
    
    func addSuccesor(_ block: ARMInstructionBlock) {
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
        }
    }
}
