//
//  LLVMInstructionBlockSequence+removeTrivialPhis.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension Sequence where Element: LLVMInstructionBlock {
    func removeTrivialPhis() {
        while let blockWithTrivialPhi = first(where: \.hasTrivialPhi) {
            guard let (index, trivialPhi) = blockWithTrivialPhi.firstTrivialPhi else { continue }
            guard let representativeOperand = trivialPhi.representativeOperand else {
                blockWithTrivialPhi.instructions.remove(at: index)
                continue
            }
            
            trivialPhi.target.replaceAllUses(withValue: representativeOperand.value)
            blockWithTrivialPhi.instructions.remove(at: index)
        }
    }
}
