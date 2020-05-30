//
//  LLVMInstructionArray+armInstructions.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension Sequence where Element == LLVMInstruction {
    func getARMInstructions(withContext context: CodeGenerationContext) -> [ARMInstruction] {
        
        flatMap({ instruction in
            instruction.getArmInstructions(withContext: context)
        })
    }
}
