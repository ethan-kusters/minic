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
    private(set) var phiInstructions = [LLVMPhiInstruction]()
    
    var instructions = [LLVMInstruction]()
    var predecessors = [Block]()
    var successors = [Block]()
    
    private var identifierMapping = [LLVMIdentifier : LLVMValue]()
    
    private(set) var sealed = false
    
    init(_ description: String, sealed: Bool = true) {
        self.label = Block.getLabel(description)
        self.sealed = sealed
    }
    
    init(_ description: String, instructions: [LLVMInstruction]) {
        self.label = Block.getLabel(description)
        self.instructions = instructions
    }
    
    func addPredecessor(_ block: Block) {
        predecessors.append(block)
    }
    
    func addSuccesor(_ block: Block) {
        successors.append(block)
    }
    
    func addInstructions(_ newInstructions: [LLVMInstruction]) {
        instructions.append(contentsOf: newInstructions)
    }
    
    func addInstruction(_ newInstruction: LLVMInstruction) {
        instructions.append(newInstruction)
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
    
    func readVariableFromPredecessors(_ id: LLVMIdentifier) -> LLVMValue {
        let value: LLVMValue
        
        if !sealed {
            // this CFG is not complete, the block might gain a predecessor
            // thus the need for a phi is unclear, so let’s assume it is needed
            let phiInstruction = LLVMPhiInstruction(inBlock: self, forID: id, incomplete: true)
            phiInstructions.append(phiInstruction)
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
            phiInstructions.append(phiInstruction)
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
