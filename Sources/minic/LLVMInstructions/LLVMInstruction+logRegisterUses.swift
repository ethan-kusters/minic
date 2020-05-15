//
//  LLVMInstruction+logRegisterUses.swift
//  minic
//
//  Created by Ethan Kusters on 5/9/20.
//

import Foundation

extension LLVMInstruction {
    func logRegisterUses() -> LLVMInstruction {
        switch(self) {
        case let .add(target, firstOp, secondOp, _),
             let .subtract(target, firstOp, secondOp, _),
             let .multiply(target, firstOp, secondOp, _),
             let .signedDivide(target, firstOp, secondOp, _),
             let .and(target, firstOp, secondOp, _),
             let .or(target, firstOp, secondOp, _),
             let .exclusiveOr(target, firstOp, secondOp, _),
             let .comparison(target, _, firstOp, secondOp, _):
            
            firstOp.addUse(by: self)
            secondOp.addUse(by: self)
            target.setDefiningInstruction(self)
        case let .conditionalBranch(conditional, _, _, _):
            conditional.addUse(by: self)
        case .unconditionalBranch:
            return self
        case let .load(target, _, _):
            target.setDefiningInstruction(self)
        case let .store(source, _, _):
            source.addUse(by: self)
        case let .getElementPointer(target, _, _, _, _):
            target.setDefiningInstruction(self)
        case let .returnValue(value, _):
            value.addUse(by: self)
        case let .allocate(target, _):
            target.setDefiningInstruction(self)
        case let .bitcast(target, source, _):
            source.addUse(by: self)
            target.setDefiningInstruction(self)
        case let .truncate(target, source, _):
            source.addUse(by: self)
            target.setDefiningInstruction(self)
        case let .zeroExtend(target, source, _):
            source.addUse(by: self)
            target.setDefiningInstruction(self)
        case let .call(target, _, arguments, _):
            arguments.forEach({$0.addUse(by: self)})
            target?.setDefiningInstruction(self)
        case .declareGlobal, .declareStructureType, .returnVoid:
            return self
        }
        
        return self
    }
}
