//
//  LLVMInstruction+block.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension LLVMInstruction {
    var block: LLVMInstructionBlock {
        switch(self) {
        case let .add(_, _, _, block),
             let .subtract(_, _, _, block),
             let .multiply(_, _, _, block),
             let .signedDivide(_, _, _, block),
             let .and(_, _, _, block),
             let .or(_, _, _, block),
             let .exclusiveOr(_, _, _, block),
             let .comparison(_, _, _, _, block),
             let .conditionalBranch(_, _, _, block),
             let .unconditionalBranch(_, block),
             let .load(_, _, block), let .store(_, _, block),
             let .getElementPointer(_, _, _, _, block),
             let .returnValue(_, block),
             let .returnVoid(block),
             let .allocate(_, block),
             let .bitcast(_, _, block),
             let .truncate(_, _, block),
             let .zeroExtend(_, _, block),
             let .call(_, _, _, block),
             let .move(_, _, block),
             let .print(_, block),
             let .println(_, block),
             let .read(_, block):
            
            return block
        case let .phi(phiInstruction):
            return phiInstruction.block
        case .declareGlobal, .declareStructureType:
            fatalError("Cannot get block from declaration statement. Declarations are not stored in blocks.")
        }
    }
}
