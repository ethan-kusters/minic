//
//  BlockArray+removeTrivialPhis.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension Array where Element: Block {
    var firstBlockWithTrivialPhi: Block? {
        first(where: \.hasTrivialPhi)
    }
    
    func removeTrivialPhis() {
        while let blockWithTrivialPhi = firstBlockWithTrivialPhi {
            guard let (index, trivialPhi) = blockWithTrivialPhi.firstTrivialPhi else { continue }
            guard let representativeOperand = trivialPhi.representativeOperand else {
                blockWithTrivialPhi.instructions.remove(at: index)
                continue
            }
            
            trivialPhi.target.uses.forEach { instruction in
                let newInstruction = instruction.replacingRegister(trivialPhi.target, with: representativeOperand.value).logRegisterUses()
                instruction.block.replaceInstruction(instruction, with: newInstruction)
            }
            
            blockWithTrivialPhi.instructions.remove(at: index)
        }
    }
}
