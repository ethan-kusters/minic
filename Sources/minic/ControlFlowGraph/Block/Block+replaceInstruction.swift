//
//  Block+replaceInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 5/15/20.
//

import Foundation

extension Block {
    func replaceInstruction(_ currentInstruction: LLVMInstruction, with newInstruction: LLVMInstruction) {
        if let index = instructions.firstIndex(of: currentInstruction) {
            instructions[index] = newInstruction
        }
    }
}
