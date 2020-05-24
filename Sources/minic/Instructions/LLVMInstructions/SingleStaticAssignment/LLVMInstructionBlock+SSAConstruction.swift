//
//  LLVMInstructionBlock+SSAConstruction.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

/// This extension adds SSA construction functionality to the InstructionBlock.
///
/// # Reference
/// [Simple and Efficient Construction of Static Single Assignment Form](https://compilers.cs.uni-saarland.de/papers/bbhlmz13cc.pdf)
extension InstructionBlock where InstructionType == LLVMInstruction {
    
    // MARK: - Phi Instructions
    
    var phiInstructions: [LLVMPhiInstruction] {
        instructions.compactMap { instruction -> LLVMPhiInstruction? in
            guard case let .phi(phiInstruction) = instruction else { return nil }
            return phiInstruction
        }
    }
    
    var hasTrivialPhi: Bool {
        phiInstructions.contains(where: \.trivial)
    }
    
    var firstTrivialPhi: (index: Int, phi: LLVMPhiInstruction)? {
        guard let index = instructions.firstIndex(where: { instruction in
            guard case let .phi(phiInstruction) = instruction else { return false }
            return phiInstruction.trivial
        }) else { return nil }
        
        guard case let .phi(phiInstruction) = instructions[index] else { return nil }
        return (index, phiInstruction)
    }
    
    // MARK: - SSA Phi Implementation
    
    func addPhiInstruction(_ newInstruction: LLVMPhiInstruction) {
        instructions.insert(.phi(newInstruction), at: 0)
    }
    
    func writeVariable(_ id: LLVMIdentifier, asValue value: LLVMValue) {
        identifierMapping[id] = value
    }
    
    func readVariable(_ id: LLVMIdentifier) -> LLVMValue {
        if let val = identifierMapping[id] {
            return val
        } else {
            return readVariableFromPredecessors(id)
        }
    }
    
    private func readVariableFromPredecessors(_ id: LLVMIdentifier) -> LLVMValue {
        let value: LLVMValue
        
        if !sealed {
            // this CFG is not complete, the block might gain a predecessor
            // thus the need for a phi is unclear, so let’s assume it is needed
            let phiInstruction = LLVMPhiInstruction(inBlock: self, forID: id, incomplete: true)
            addPhiInstruction(phiInstruction)
            value = .register(phiInstruction.target)
        } else if predecessors.isEmpty {
            value = .null(id.type)
        } else if predecessors.count == 1 {
            // there is only one predecessor (and the block is sealed)
            value = predecessors.first!.readVariable(id)
        } else {
            // ok, let’s search through predecessors and join them
            // with a phi instruction at the beginning of this block
            let phiInstruction = LLVMPhiInstruction(inBlock: self, forID: id)
            addPhiInstruction(phiInstruction)
            value = .register(phiInstruction.target)
            
            // variable maps to new value which breaks cycles
            writeVariable(id, asValue: value)
            
            // Complete the phi instruction
            phiInstruction.addOperands()
        }
        
        writeVariable(id, asValue: value )
        return value
    }
    
    func seal() {
        guard !sealed else { return }
        sealed = true
        
        for phi in phiInstructions where phi.incomplete {
            phi.addOperands()
            phi.incomplete = false
        }
    }
    
    func removeTrivialPhis() {
        while let (index, currentPhi) = firstTrivialPhi {
            guard let representativeOperand = currentPhi.representativeOperand else {
                instructions.remove(at: index)
                continue
            }
            
            currentPhi.target.uses.forEach { instruction in
                let newInstruction = instruction.replacingRegister(currentPhi.target, with: representativeOperand.value).logRegisterUses()
                instruction.block.replaceInstruction(instruction, with: newInstruction)
            }
            
            instructions.remove(at: index)
        }
    }
}
