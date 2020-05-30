//
//  ARMInstruction+computerGenKillSets.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstructionBlock {
    func computeGenKillSets(_ context: CodeGenerationContext) {
        instructions.forEach { instruction in
            instruction.sources.forEach { usedRegister in
                if !killedVariables.contains(usedRegister) {
                    generatedVariables.insert(usedRegister)
                }
            }
            
            instruction.getTargets(context).forEach { definedRegister in
                killedVariables.insert(definedRegister)
            }
        }
    }
}
