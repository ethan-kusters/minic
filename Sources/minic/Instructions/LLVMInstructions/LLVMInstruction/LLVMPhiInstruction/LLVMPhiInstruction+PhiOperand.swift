//
//  LLVMPhiInstruction+PhiOperand.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension LLVMPhiInstruction {
    struct PhiOperand: Equatable {
        let value: LLVMValue
        let block: InstructionBlock<LLVMInstruction>
    }
}
