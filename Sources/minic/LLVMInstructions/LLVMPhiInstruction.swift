//
//  LLVMPhiInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 5/10/20.
//

import Foundation

/// The ‘phi’ instruction is used to implement the φ node in the SSA graph representing the function.
///
/// # Reference
/// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#phi-instruction)
class LLVMPhiInstruction: LLVMInstructionProtocol {
    var operands = [PhiOperand]()
    let block: Block
    let destination: LLVMVirtualRegister
    let associatedIdentifier: LLVMIdentifier
    var incomplete: Bool
    
    init(inBlock block: Block, forID id: LLVMIdentifier, incomplete: Bool = false) {
        self.block = block
        self.destination = LLVMVirtualRegister(withPrefix: id.rawIdentifier, type: id.type)
        self.incomplete = incomplete
        self.associatedIdentifier = id
        self.destination.setDefiningInstruction(self)
    }
    
    func addOperands() {
        block.predecessors.forEach { predecessor in
            let value = predecessor.readVariable(associatedIdentifier)
            value.addUse(by: self)
            operands.append(PhiOperand(value: value, block: predecessor))
        }
    }
    
    struct PhiOperand: Equatable {
        let value: LLVMValue
        let block: Block
    }
}
