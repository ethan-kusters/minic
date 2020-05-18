//
//  BlockSequence+removeTrivialPhis.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension Sequence where Element: Block {
    func removeTrivialPhis() {
        while let blockWithTrivialPhi = first(where: \.hasTrivialPhi) {
            guard let (index, trivialPhi) = blockWithTrivialPhi.firstTrivialPhi else { continue }
            guard let representativeOperand = trivialPhi.representativeOperand else {
                blockWithTrivialPhi.instructions.remove(at: index)
                continue
            }
            
            trivialPhi.target.uses.forEach { instruction in
                let newInstruction = instruction.replacingRegister(trivialPhi.target, with: representativeOperand.value).logRegisterUses()
                instruction.block.replaceInstruction(instruction, with: newInstruction)
            }
            
            trivialPhi.target.removeAllUses()
            blockWithTrivialPhi.instructions.remove(at: index)
        }
    }
}
