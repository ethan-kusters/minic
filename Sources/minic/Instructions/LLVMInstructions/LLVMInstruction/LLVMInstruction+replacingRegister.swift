//
//  LLVMInstruction+replacingRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/15/20.
//

import Foundation

extension LLVMInstruction {
    func replacingRegister(_ oldRegister: LLVMVirtualRegister, with newValue: LLVMValue) -> LLVMInstruction {
        if case let .register(register) = newValue {
            return replacingRegister(oldRegister, with: register)
        }
        
        switch(self) {
        case let .add(target, firstOp, secondOp, block):
            return LLVMInstruction.add(target: target,
                                       firstOp: firstOp == oldRegister ? newValue : firstOp,
                                       secondOp: secondOp == oldRegister ? newValue : secondOp,
                                       block: block)
        case let .subtract(target, firstOp, secondOp, block):
            return LLVMInstruction.subtract(target: target,
                                            firstOp: firstOp == oldRegister ? newValue : firstOp,
                                            secondOp: secondOp == oldRegister ? newValue : secondOp,
                                            block: block)
        case let .multiply(target, firstOp, secondOp, block):
            return LLVMInstruction.multiply(target: target,
                                            firstOp: firstOp == oldRegister ? newValue : firstOp,
                                            secondOp: secondOp == oldRegister ? newValue : secondOp,
                                            block: block)
        case let .signedDivide(target, firstOp, secondOp, block):
            return LLVMInstruction.signedDivide(target: target,
                                                firstOp: firstOp == oldRegister ? newValue : firstOp,
                                                secondOp: secondOp == oldRegister ? newValue : secondOp,
                                                block: block)
        case let .and(target, firstOp, secondOp, block):
            return LLVMInstruction.and(target: target,
                                       firstOp: firstOp == oldRegister ? newValue : firstOp,
                                       secondOp: secondOp == oldRegister ? newValue : secondOp,
                                       block: block)
        case let .or(target, firstOp, secondOp, block):
            return LLVMInstruction.or(target: target,
                                      firstOp: firstOp == oldRegister ? newValue : firstOp,
                                      secondOp: secondOp == oldRegister ? newValue : secondOp,
                                      block: block)
        case let .exclusiveOr(target, firstOp, secondOp, block):
            return LLVMInstruction.exclusiveOr(target: target,
                                               firstOp: firstOp == oldRegister ? newValue : firstOp,
                                               secondOp: secondOp == oldRegister ? newValue : secondOp,
                                               block: block)
        case let .comparison(target, condCode, firstOp, secondOp, block):
            return LLVMInstruction.comparison(target: target,
                                              condCode: condCode,
                                              firstOp: firstOp == oldRegister ? newValue : firstOp,
                                              secondOp: secondOp == oldRegister ? newValue : secondOp,
                                              block: block)
        case let .conditionalBranch(conditional, ifTrue, ifFalse, block):
            return LLVMInstruction.conditionalBranch(conditional: conditional == oldRegister ? newValue : conditional,
                                                     ifTrue: ifTrue,
                                                     ifFalse: ifFalse,
                                                     block: block)
        case .unconditionalBranch:
            return self
        case .load:
            return self
        case let .store(source, destPointer, block):
            return LLVMInstruction.store(source: source == oldRegister ? newValue : source,
                                         destPointer: destPointer ,
                                         block: block)
        case .getElementPointer:
            return self
        case let .returnValue(retVal, block):
            return LLVMInstruction.returnValue(retVal == oldRegister ? newValue : retVal,
                                               block: block)
        case .allocate:
            return self
        case let .bitcast(target, source, block):
            return LLVMInstruction.bitcast(target: target,
                                           source: source == oldRegister ? newValue : source,
                                           block: block)
        case let .truncate(target, source, block):
            return LLVMInstruction.truncate(target: target,
                                            source: source == oldRegister ? newValue : source,
                                            block: block)
        case let .zeroExtend(target, source, block):
            return LLVMInstruction.zeroExtend(target: target,
                                              source: source == oldRegister ? newValue : source,
                                              block: block)
        case let .call(target, functionIdentifier, arguments, block):
            let newArgs = arguments.map { arg -> LLVMValue in
                guard arg == oldRegister else { return arg }
                return newValue
            }
            
            return LLVMInstruction.call(target: target,
                                        functionIdentifier: functionIdentifier, arguments: newArgs,
                                        block: block)
        case let .phi(phiInstruction):
            return .phi(phiInstruction.replacingRegister(oldRegister, with: newValue))
        case let .move(target, source, block):
            return .move(target: target,
                         source: source == oldRegister ? newValue : source,
                         block: block)
        case .declareGlobal, .declareStructureType, .returnVoid:
            return self
        }
    }
    
    func replacingRegister(_ oldRegister: LLVMVirtualRegister, with newRegister: LLVMVirtualRegister) -> LLVMInstruction {
        switch(self) {
        case let .add(target, firstOp, secondOp, block):
            return LLVMInstruction.add(target: target == oldRegister ? newRegister : target,
                                       firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                       secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                       block: block)
        case let .subtract(target, firstOp, secondOp, block):
            return LLVMInstruction.subtract(target: target == oldRegister ? newRegister : target,
                                            firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                            secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                            block: block)
        case let .multiply(target, firstOp, secondOp, block):
            return LLVMInstruction.multiply(target: target == oldRegister ? newRegister : target,
                                            firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                            secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                            block: block)
        case let .signedDivide(target, firstOp, secondOp, block):
            return LLVMInstruction.signedDivide(target: target == oldRegister ? newRegister : target,
                                                firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                                secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                                block: block)
        case let .and(target, firstOp, secondOp, block):
            return LLVMInstruction.and(target: target == oldRegister ? newRegister : target,
                                       firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                       secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                       block: block)
        case let .or(target, firstOp, secondOp, block):
            return LLVMInstruction.or(target: target == oldRegister ? newRegister : target,
                                      firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                      secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                      block: block)
        case let .exclusiveOr(target, firstOp, secondOp, block):
            return LLVMInstruction.exclusiveOr(target: target == oldRegister ? newRegister : target,
                                               firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                               secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                               block: block)
        case let .comparison(target, condCode, firstOp, secondOp, block):
            return LLVMInstruction.comparison(target: target == oldRegister ? newRegister : target,
                                              condCode: condCode,
                                              firstOp: firstOp == oldRegister ? .register(newRegister) : firstOp,
                                              secondOp: secondOp == oldRegister ? .register(newRegister) : secondOp,
                                              block: block)
        case let .conditionalBranch(conditional, ifTrue, ifFalse, block):
            return LLVMInstruction.conditionalBranch(conditional: conditional == oldRegister ? .register(newRegister) : conditional,
                                                     ifTrue: ifTrue,
                                                     ifFalse: ifFalse,
                                                     block: block)
        case .unconditionalBranch:
            return self
        case let .load(target, srcPointer, block):
            return LLVMInstruction.load(target: target == oldRegister ? newRegister : target,
                                        srcPointer: srcPointer == oldRegister ? newRegister.identifier : srcPointer,
                                        block: block)
        case let .store(source, destPointer, block):
            return LLVMInstruction.store(source: source == oldRegister ? .register(newRegister) : source,
                                         destPointer: destPointer == oldRegister ? newRegister.identifier : destPointer,
                                         block: block)
        case let .getElementPointer(target, structureType, structurePointer, elementIndex, block):
            return LLVMInstruction.getElementPointer(target: target == oldRegister ? newRegister : target,
                                                     structureType: structureType == oldRegister ? newRegister.identifier : structureType,
                                                     structurePointer: structurePointer == oldRegister ? newRegister.identifier : structureType,
                                                     elementIndex: elementIndex,
                                                     block: block)
        case let .returnValue(retVal, block):
            return LLVMInstruction.returnValue(retVal == oldRegister ? .register(newRegister) : retVal,
                                               block: block)
        case let .allocate(target, block):
            return LLVMInstruction.allocate(target: target == oldRegister ? newRegister : target,
                                            block: block)
        case let .bitcast(target, source, block):
            return LLVMInstruction.bitcast(target: target == oldRegister ? newRegister : target,
                                           source: source == oldRegister ? .register(newRegister) : source,
                                           block: block)
        case let .truncate(target, source, block):
            return LLVMInstruction.truncate(target: target == oldRegister ? newRegister : target,
                                            source: source == oldRegister ? .register(newRegister) : source,
                                            block: block)
        case let .zeroExtend(target, source, block):
            return LLVMInstruction.zeroExtend(target: target == oldRegister ? newRegister : target,
                                              source: source == oldRegister ? .register(newRegister) : source,
                                              block: block)
        case let .call(target, functionIdentifier, arguments, block):
            let newArgs = arguments.map { arg -> LLVMValue in
                guard arg == oldRegister else { return arg }
                return .register(newRegister)
            }
            
            return LLVMInstruction.call(target: target == oldRegister ? newRegister : target,
                                        functionIdentifier: functionIdentifier, arguments: newArgs,
                                        block: block)
        case let .phi(phiInstruction):
            return .phi(phiInstruction.replacingRegister(oldRegister, with: .register(newRegister)))
        case let .move(target, source, block):
            return .move(target: target == oldRegister ? newRegister : target,
                         source: source == oldRegister ? .register(newRegister) : source,
                         block: block)
        case .declareGlobal, .declareStructureType, .returnVoid:
            return self
        }
    }
    
}
