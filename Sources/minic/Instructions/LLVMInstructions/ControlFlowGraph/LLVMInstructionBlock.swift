//
//  LLVMInstructionBlock.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

extension InstructionBlock where InstructionType == LLVMInstruction {
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
    
    convenience init(_ description: String, sealed: Bool = true) {
        self.init(label: InstructionBlock.getUniqueLabel(description),
                  sealed: sealed)
    }
}
