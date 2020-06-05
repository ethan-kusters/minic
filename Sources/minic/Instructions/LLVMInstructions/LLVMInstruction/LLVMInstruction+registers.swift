//
//  LLVMInstruction+registers.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMInstruction {
    var registers: [LLVMVirtualRegister] {
        switch(self) {
        case let .add(target, firstOp, secondOp, _),
             let .subtract(target, firstOp, secondOp, _),
             let .multiply(target, firstOp, secondOp, _),
             let .signedDivide(target, firstOp, secondOp, _),
             let .and(target, firstOp, secondOp, _),
             let .or(target, firstOp, secondOp, _),
             let .exclusiveOr(target, firstOp, secondOp, _),
             let .comparison(target, _, firstOp, secondOp, _):
            return [firstOp.asRegister, secondOp.asRegister, target].compact()
        case let .conditionalBranch(conditional, _, _, _):
            return [conditional.asRegister].compact()
        case .unconditionalBranch:
            return []
        case let .load(target, srcPointer, _):
            return [target, srcPointer.asRegister].compact()
        case let .store(source, destPointer, _):
            return [source.asRegister, destPointer.asRegister].compact()
        case let .getElementPointer(target, structureType, structurePointer, _, _):
            return [structureType.asRegister, structurePointer.asRegister, target].compact()
        case let .returnValue(value, _):
            return [value.asRegister].compact()
        case let .allocate(target, _):
            return [target]
        case let .bitcast(target, source, _),
             let .truncate(target, source, _),
             let .zeroExtend(target, source, _):
            return [source.asRegister, target].compact()
        case let .call(target, _, arguments, _):
            return [[target].compact(), arguments.map(\.asRegister).compact()].flatten()
        case let .phi(phiInstruction):
            return [[phiInstruction.target], phiInstruction.operands.map(\.value).map(\.asRegister).compact()].flatten()
        case let .move(target, source, _):
            return [target, source.asRegister].compact()
        case let .println(source, _),
             let .print(source, _):
            return [source.asRegister].compact()
        case let .read(target, _):
            return [target]
        case .declareGlobal, .declareStructureType, .returnVoid:
            return []
        }
    }
}
