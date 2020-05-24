//
//  LLVMInstruction+armInstructions.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMInstruction {
    var armInstructions: [ARMInstruction] {
        switch(self) {
        case let .add(target, firstOp, secondOp, _):
            let (movInstr, firstReg) = firstOp.armRegister
            let addInstr = ARMInstruction.add(target: target.armRegister,
                                              firstOp: firstReg,
                                              secondOp: secondOp.armFlexibleOperand)
            return [movInstr, addInstr].compactMap({$0})
        case let .subtract(target, firstOp, secondOp, _):
            let (movInstr, firstReg) = firstOp.armRegister
            let subInstr = ARMInstruction.subtract(target: target.armRegister,
                                                   firstOp: firstReg,
                                                   secondOp: secondOp.armFlexibleOperand)
            return [movInstr, subInstr].compact()
        case let .multiply(target, firstOp, secondOp, _):
            let (firstMovInstr, firstReg) = firstOp.armRegister
            let (secondMovInstr, secondReg) = secondOp.armRegister
            
            let multInstr = ARMInstruction.multiply(target: target.armRegister,
                                                   firstOp: firstReg,
                                                   secondOp: secondReg)
            return [firstMovInstr, secondMovInstr, multInstr].compact()
        case let .signedDivide(target, firstOp, secondOp, _):
            let (firstMovInstr, firstReg) = firstOp.armRegister
            let (secondMovInstr, secondReg) = secondOp.armRegister
            
            let divInstr = ARMInstruction.signedDivide(target: target.armRegister,
                                                       firstOp: firstReg,
                                                       secondOp: secondReg)
            
            return [firstMovInstr, secondMovInstr, divInstr].compact()
        case let .and(target, firstOp, secondOp, _):
            let (movInstr, firstReg) = firstOp.armRegister
            let andInstr = ARMInstruction.and(target: target.armRegister,
                                              firstOp: firstReg,
                                              secondOp: secondOp.armFlexibleOperand)
            
            return [movInstr, andInstr].compact()
        case let .or(target, firstOp, secondOp, _):
            let (movInstr, firstReg) = firstOp.armRegister
            let orInstr = ARMInstruction.or(target: target.armRegister,
                                            firstOp: firstReg,
                                            secondOp: secondOp.armFlexibleOperand)
            
            return [movInstr, orInstr].compact()
        case let .exclusiveOr(target, firstOp, secondOp, _):
            let (movInstr, firstReg) = firstOp.armRegister
            let orInstr = ARMInstruction.exclusiveOr(target: target.armRegister,
                                                     firstOp: firstReg,
                                                     secondOp: secondOp.armFlexibleOperand)
            
            return [movInstr, orInstr].compact()
        case let .comparison(target, condCode, firstOp, secondOp, _):
            let falseMoveInstr = ARMInstruction.move(condCode: nil,
                                                     target: target.armRegister,
                                                     source: .constant(ARMInstructionConstants.falseValue))
            
            let (regMovInstr, firstReg) = firstOp.armRegister
            let cmpInstr = ARMInstruction.compare(firstOp: firstReg,
                                                   secondOp: secondOp.armFlexibleOperand)
            
            let condMovInstr = ARMInstruction.move(condCode: condCode.armConditionCode,
                                                   target: target.armRegister,
                                                   source: .constant(ARMInstructionConstants.trueValue))
            
            return [falseMoveInstr, regMovInstr, cmpInstr, condMovInstr].compact()
        case let .conditionalBranch(conditional, ifTrue, ifFalse, _):
            let (movInstr, firstReg) = conditional.armRegister
            
            let cmpInstr = ARMInstruction.compare(firstOp: firstReg,
                                                  secondOp: .constant(ARMInstructionConstants.trueValue))
            
            let ifTrueBranch = ARMInstruction.branch(condCode: .EQ,
                                                          label: ifTrue.armLabel)
            let ifFalseBranch = ARMInstruction.branch(condCode: nil,
                                                      label: ifFalse.armLabel)
            
            return [movInstr, cmpInstr, ifTrueBranch, ifFalseBranch].compact()
        case let .unconditionalBranch(destLabel, _):
            let brInstr = ARMInstruction.branch(condCode: nil, label: destLabel.armLabel)
            
            return [brInstr]
        case let .load(target, srcPointer, _):
            let (movInstr, srcReg) = srcPointer.armRegister
            
            let ldInstr = ARMInstruction.load(target: target.armRegister,
                                              sourceAddress: srcReg)
            
            return [movInstr, ldInstr].compact()
        case let .store(source, destPointer, _):
            let (srcMovInstr, srcReg) = source.armRegister
            let (trgMovInstr, trgRrg) = destPointer.armRegister
            
            let storeInstruction = ARMInstruction.store(source: srcReg,
                                                        targetAddress: trgRrg)
            
            return [srcMovInstr, trgMovInstr, storeInstruction].compact()
        case let .getElementPointer(target, _, structurePointer, elementIndex, _):
            let (ptrMovInstr, ptrReg) = structurePointer.armRegister
            let offset = elementIndex * ARMInstructionConstants.numberOfBytesPerStructField
            
            let addInstr = ARMInstruction.add(target: target.armRegister,
                                              firstOp: ptrReg,
                                              secondOp: .constant(offset))
            
            return [ptrMovInstr, addInstr].compact()
        case let .call(target, functionIdentifier, arguments, _):
            var movArgInstrs = [ARMInstruction]()
            for (index, argument) in arguments.enumerated() {
                guard index < 3 else { fatalError("ToDo: Add support for >3 args")}
                
                movArgInstrs.append(.move(condCode: nil,
                                          target: index.armRealRegister,
                                          source: argument.armFlexibleOperand))
            }
            
            let blInstr = ARMInstruction.branchWithLink(label: functionIdentifier.armLabel)
            
            var movRetValInstr: ARMInstruction?
            if let target = target {
                movRetValInstr = .move(condCode: nil,
                                       target: target.armRegister,
                                       source: .register(.real(0)))
            }
            
            return movArgInstrs + [blInstr, movRetValInstr].compact()
        case let .returnValue(retVal, _):
            let movRetVal = ARMInstruction.move(condCode: nil,
                                                target: .real(0),
                                                source: retVal.armFlexibleOperand)
            
            let popInstr = ARMInstruction.pop(registers: [.real(.framePointer), .real(.programCounter)])
            
            return [movRetVal, popInstr]
        case .returnVoid:
            let popInstr = ARMInstruction.pop(registers: [.real(.framePointer), .real(.programCounter)])
            
            return [popInstr]
        case let .allocate(target, _):
            let spSubInstr = ARMInstruction.subtract(target: .real(.stackPointer),
                                                     firstOp: .real(.stackPointer),
                                                     secondOp: .constant(4))
            
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target.armRegister,
                                               source: .register(.real(.stackPointer)))
            
            return [spSubInstr, movInstr]
        case let .declareGlobal(target, _):
            return [.declareGlobal(label: target.armLabel)]
        case .declareStructureType:
            return []
        case let .bitcast(target, source, _):
            target.replaceAllUses(withValue: source)
            return []
        case let .truncate(target, source, _):
            target.replaceAllUses(withValue: source)
            return []
        case let .zeroExtend(target, source, _):
            target.replaceAllUses(withValue: source)
            return []
        case .phi:
            fatalError("Phi has no equivalent in Assembly.")
        case let .move(target, source, _):
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target.armRegister,
                                               source: source.armFlexibleOperand)
            
            return [movInstr]
        }
    }
}
