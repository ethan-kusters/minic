//
//  LLVMInstructionBlock+firstUselessInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 6/1/20.
//

import Foundation

extension LLVMInstructionBlock {
    var firstUselessInstruction: LLVMInstruction? {
        instructions.first(where: \.isUseless)
    }
}
