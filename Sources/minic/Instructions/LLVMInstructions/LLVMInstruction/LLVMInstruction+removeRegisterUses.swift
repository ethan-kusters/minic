//
//  LLVMInstruction+removeRegisterUses.swift
//  Antlr4
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension LLVMInstruction {
    func removeRegisterUses() {
        switch(self) {
        case let .add(target, firstOp, secondOp, _),
             let .subtract(target, firstOp, secondOp, _),
             let .multiply(target, firstOp, secondOp, _),
             let .signedDivide(target, firstOp, secondOp, _),
             let .and(target, firstOp, secondOp, _),
             let .or(target, firstOp, secondOp, _),
             let .exclusiveOr(target, firstOp, secondOp, _),
             let .comparison(target, _, firstOp, secondOp, _):
            firstOp.removeUse(by: self)
            secondOp.removeUse(by: self)
            target.removeDefiningInstruction(self)
        case let .conditionalBranch(conditional, _, _, _):
            conditional.removeUse(by: self)
        case .unconditionalBranch:
            return
        case let .load(target, srcPointer, _):
            srcPointer.removeUse(self)
            target.removeDefiningInstruction(self)
        case let .store(source, destPointer, _):
            source.removeUse(by: self)
            destPointer.removeUse(self)
        case let .getElementPointer(target, structureType, structurePointer, _, _):
            structureType.removeUse(self)
            structurePointer.removeUse(self)
            target.removeDefiningInstruction(self)
        case let .returnValue(value, _):
            value.removeUse(by: self)
        case let .allocate(target, _):
            target.removeDefiningInstruction(self)
        case let .bitcast(target, source, _):
            source.removeUse(by: self)
            target.removeDefiningInstruction(self)
        case let .truncate(target, source, _):
            source.removeUse(by: self)
            target.removeDefiningInstruction(self)
        case let .zeroExtend(target, source, _):
            source.removeUse(by: self)
            target.removeDefiningInstruction(self)
        case let .call(target, _, arguments, _):
            arguments.forEach({$0.removeUse(by: self)})
            target?.removeDefiningInstruction(self)
        case let .phi(phiInstruction):
            phiInstruction.operands.map(\.value).forEach { $0.removeUse(by: self) }
            phiInstruction.target.removeDefiningInstruction(self)
        case let .move(target, source, _):
            target.removeDefiningInstruction(self)
            source.removeUse(by: self)
        case .declareGlobal, .declareStructureType, .returnVoid:
            return
        }
    }
}
