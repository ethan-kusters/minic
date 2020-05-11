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
        case let .add(firstOp, secondOp, destination),
             let .subtract(firstOp, secondOp, destination),
             let .multiply(firstOp, secondOp, destination),
             let .signedDivide(firstOp, secondOp, destination),
             let .and(firstOp, secondOp, destination),
             let .or(firstOp, secondOp, destination),
             let .exclusiveOr(firstOp, secondOp, destination),
             let .comparison(_, firstOp, secondOp, destination):
            firstOp.addUse(by: self)
            secondOp.addUse(by: self)
            destination.setDefiningInstruction(self)
        case let .conditionalBranch(conditional, _, _):
            conditional.addUse(by: self)
        case .unconditionalBranch:
            return self
        case let .load(_, destination):
            destination.setDefiningInstruction(self)
        case let .store(source, _):
            source.addUse(by: self)
        case let .getElementPointer(_, _, _, destination):
            destination.setDefiningInstruction(self)
        case let .returnValue(value):
            value.addUse(by: self)
        case .returnVoid:
            return self
        case let .allocate(destination):
            destination.setDefiningInstruction(self)
        case .declareGlobal,
             .declareStructureType:
            return self
        case let .bitcast(source, destination):
            source.addUse(by: self)
            destination.setDefiningInstruction(self)
        case let .truncate(source, destination):
            source.addUse(by: self)
            destination.setDefiningInstruction(self)
        case let .zeroExtend(source, destination):
            source.addUse(by: self)
            destination.setDefiningInstruction(self)
        case let .call(_, arguments, destination):
            arguments.forEach({$0.addUse(by: self)})
            destination?.setDefiningInstruction(self)
        case let .phi(valuePairs, destination):
            valuePairs.forEach { valuePair in
                valuePair.value.addUse(by: self)
            }
            
            destination.setDefiningInstruction(self)
        }
        
        return self
    }
}
