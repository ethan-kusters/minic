//
//  LLVMPhiInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 5/10/20.
//

import Foundation

class LLVMPhiInstruction {
    var operands = [PhiOperand]()
    let block: Block
    let destination: LLVMVirtualRegister
    let associatedIdentifier: LLVMIdentifier
    var incomplete: Bool
    
    init(inBlock block: Block, forID id: LLVMIdentifier, incomplete: Bool = false) {
        self.block = block
        self.destination = LLVMVirtualRegister(ofType: id.type)
        self.incomplete = incomplete
        self.associatedIdentifier = id
    }
    
    func addOperands() {
        block.predecessors.forEach { predecessor in
            let value = predecessor.readVariable(associatedIdentifier)
            operands.append(PhiOperand(value: value, block: predecessor))
        }
    }
    
    struct PhiOperand: Equatable {
        let value: LLVMValue
        let block: Block
    }
}
