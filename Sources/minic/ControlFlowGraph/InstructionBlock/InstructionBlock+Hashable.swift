//
//  LLVMInstructionBlock+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension LLVMInstructionBlock {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: LLVMInstructionBlock, rhs: LLVMInstructionBlock) -> Bool {
        lhs.label == rhs.label
            && lhs.uuid == rhs.uuid
            && lhs.sealed == rhs.sealed
    }
}
