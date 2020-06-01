//
//  LLVMInstruction+isUseless.swift
//  minic
//
//  Created by Ethan Kusters on 6/1/20.
//

import Foundation

extension LLVMInstruction {
    var isUseless: Bool {
        switch(self) {
        case let .add(target, _, _, _),
            let .subtract(target, _, _, _),
            let .multiply(target, _, _, _),
            let .signedDivide(target, _, _, _),
            let .and(target, _, _, _),
            let .or(target, _, _, _),
            let .exclusiveOr(target, _, _, _),
            let .comparison(target, _, _, _, _),
            let .load(target, _, _),
            let .getElementPointer(target, _, _, _, _),
            let .allocate(target, _),
            let .bitcast(target, _, _),
            let .truncate(target, _, _),
            let .zeroExtend(target, _, _),
            let .move(target, _, _):
            return target.uses.isEmpty
        case let .phi(phiInstruction):
            return phiInstruction.target.uses.isEmpty
        case .conditionalBranch,
             .unconditionalBranch,
             .store,
             .call,
             .returnValue,
             .returnVoid,
             .declareGlobal,
             .declareStructureType,
             .print,
             .println,
             .read:
            return false
        }
    }
}
