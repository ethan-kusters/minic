//
//  BlockArray+removeTrivialPhis.swift
//  minic
//
//  Created by Ethan Kusters on 5/11/20.
//

import Foundation

extension Array where Element == Block {
    func removeTrivialPhis() {
        forEach { block in
            while let (index, currentPhi) = block.firstTrivialPhi {
                guard let firstElement = currentPhi.operands.first else { continue }
                
                currentPhi.target.uses.forEach { instruction in
                    let newInstruction = instruction.replacingRegister(currentPhi.target, with: firstElement.value).logRegisterUses()
                    instruction.block.replaceInstruction(instruction, with: newInstruction)
                }
                
                block.instructions.remove(at: index)
            }
        }
    }
}
