//
//  LLVMPhiInstruction+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/10/20.
//

import Foundation

extension LLVMPhiInstruction: CustomStringConvertible {
    var description: String {
        guard !operands.isEmpty else {
            fatalError("Empty Phi Instruction")
        }
        
        let operandsString = operands.map { operand in
            "[ \(operand.value), %\(operand.block.label) ]"
        }.joined(separator: ", ")
                   
        return "\(destination) = phi \(destination.type) \(operandsString)"
    }
}
