//
//  ARMInstruction+computerGenKillSets.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstructionBlock {
    func computeGenKillSets() {
        instructions.forEach { instruction in
            instruction.sources.forEach { usedRegister in
                if !killedVariables.contains(usedRegister) {
                    generatedVariables.insert(usedRegister)
                }
            }
            
            instruction.targets.forEach { definedRegister in
                killedVariables.insert(definedRegister)
            }
        }
    }
}
