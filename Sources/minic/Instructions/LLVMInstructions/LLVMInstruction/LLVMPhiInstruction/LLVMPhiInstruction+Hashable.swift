//
//  LLVMPhiInstruction+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension LLVMPhiInstruction: Hashable {
    static func == (lhs: LLVMPhiInstruction, rhs: LLVMPhiInstruction) -> Bool {
        lhs.operands == rhs.operands
            && lhs.block == rhs.block
            && lhs.target == rhs.target
            && lhs.associatedIdentifier == rhs.associatedIdentifier
            && lhs.incomplete == rhs.incomplete
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(block)
        hasher.combine(target)
        hasher.combine(associatedIdentifier)
        hasher.combine(incomplete)
    }
}
