//
//  LLVMInstructionArray+armInstructions.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension Sequence where Element == LLVMInstruction {
    var armInstructions: [ARMInstruction] {
        flatMap(\.armInstructions)
    }
}
