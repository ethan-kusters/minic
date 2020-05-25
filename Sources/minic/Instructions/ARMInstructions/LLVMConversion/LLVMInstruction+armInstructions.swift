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
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armFlexibleOperand
            
            let addInstr = ARMInstruction.add(target: target.armRegister,
                                              firstOp: firstOp,
                                              secondOp: secondOp)
            
            return [firstOpInstr, secondOpInstr, [addInstr]].compactAndFlatten()
        case let .subtract(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armFlexibleOperand
            
            let subInstr = ARMInstruction.subtract(target: target.armRegister,
                                                   firstOp: firstOp,
                                                   secondOp: secondOp)
            
            return [firstOpInstr, secondOpInstr, [subInstr]].compactAndFlatten()
        case let .multiply(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armRegister
            
            let multInstr = ARMInstruction.multiply(target: target.armRegister,
                                                   firstOp: firstOp,
                                                   secondOp: secondOp)
            
            return [firstOpInstr, secondOpInstr, [multInstr]].compactAndFlatten()
        case let .signedDivide(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armRegister
            
            let divInstr = ARMInstruction.signedDivide(target: target.armRegister,
                                                   firstOp: firstOp,
                                                   secondOp: secondOp)
            
            return [firstOpInstr, secondOpInstr, [divInstr]].compactAndFlatten()
        case let .and(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armFlexibleOperand
            
            let andInstr = ARMInstruction.and(target: target.armRegister,
                                                   firstOp: firstOp,
                                                   secondOp: secondOp)
            
            return [firstOpInstr, secondOpInstr, [andInstr]].compactAndFlatten()
        case let .or(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armFlexibleOperand
            
            let orInstr = ARMInstruction.or(target: target.armRegister,
                                                   firstOp: firstOp,
                                                   secondOp: secondOp)
            
            return [firstOpInstr, secondOpInstr, [orInstr]].compactAndFlatten()
        case let .exclusiveOr(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armFlexibleOperand
            
            let xorInstr = ARMInstruction.exclusiveOr(target: target.armRegister,
                                                   firstOp: firstOp,
                                                   secondOp: secondOp)
            
            return [firstOpInstr, secondOpInstr, [xorInstr]].compactAndFlatten()
        case let .comparison(target, condCode, firstOp, secondOp, _):
            let assumeFalseInstr = ARMInstruction.move(condCode: nil,
                                                     target: target.armRegister,
                                                     source: .constant(ARMInstructionConstants.falseValue))
            
            let (firstOpInstr, firstOp) = firstOp.armRegister
            let (secondOpInstr, secondOp) = secondOp.armFlexibleOperand
            let cmpInstr = ARMInstruction.compare(firstOp: firstOp,
                                                  secondOp: secondOp)
            
            let condMovInstr = ARMInstruction.move(condCode: condCode.armConditionCode,
                                                   target: target.armRegister,
                                                   source: .constant(ARMInstructionConstants.trueValue))
            
            return [[assumeFalseInstr], firstOpInstr, secondOpInstr, [cmpInstr, condMovInstr]].compactAndFlatten()
        case let .conditionalBranch(conditional, ifTrue, ifFalse, _):
            let (condInstr, condReg) = conditional.armRegister
            
            let cmpInstr = ARMInstruction.compare(firstOp: condReg,
                                                  secondOp: .constant(ARMInstructionConstants.trueValue))
            
            let ifTrueBranch = ARMInstruction.branch(condCode: .EQ,
                                                     label: ifTrue.armSymbol)
            
            let ifFalseBranch = ARMInstruction.branch(condCode: nil,
                                                      label: ifFalse.armSymbol)
            
            return [condInstr, [cmpInstr, ifTrueBranch, ifFalseBranch]].compactAndFlatten()
        case let .unconditionalBranch(destLabel, _):
            let brInstr = ARMInstruction.branch(condCode: nil, label: destLabel.armSymbol)
            
            return [brInstr]
        case let .load(target, srcPointer, _):
            let (srcInstr, srcReg) = srcPointer.armRegister
            
            let ldInstr = ARMInstruction.load(target: target.armRegister,
                                              sourceAddress: srcReg)
            
            return [srcInstr, [ldInstr]].compactAndFlatten()
        case let .store(source, destPointer, _):
            let (srcInstr, srcReg) = source.armRegister
            let (trgInstr, trgRrg) = destPointer.armRegister
            
            let storeInstruction = ARMInstruction.store(source: srcReg,
                                                        targetAddress: trgRrg)
            
            return [srcInstr, trgInstr, [storeInstruction]].compactAndFlatten()
        case let .getElementPointer(target, _, structurePointer, elementIndex, _):
            let (ptrInstr, ptrReg) = structurePointer.armRegister
            let offset = elementIndex * ARMInstructionConstants.numberOfBytesPerStructField
            
            let addInstr = ARMInstruction.add(target: target.armRegister,
                                              firstOp: ptrReg,
                                              secondOp: .constant(offset.immediateValue))
            
            return [ptrInstr, [addInstr]].compactAndFlatten()
        case let .call(target, functionIdentifier, arguments, _):
            let movArgIntrs = arguments.enumerated().flatMap { (index, argument) -> [ARMInstruction] in
                guard index < 3 else { fatalError("ToDo: Add support for >3 args")}
                
                let (srcInstr, srcOp) = argument.armFlexibleOperand
                
                let movInstr = ARMInstruction.move(condCode: nil,
                                          target: index.armRegister,
                                          source: srcOp)
                
                return [srcInstr, [movInstr]].compactAndFlatten()
            }
            
            let blInstr = ARMInstruction.branchWithLink(label: functionIdentifier.armSymbol)
            
            var movRetValInstr: ARMInstruction?
            if let target = target {
                movRetValInstr = .move(condCode: nil,
                                       target: target.armRegister,
                                       source: .register(.real(0)))
            }
            
            return [movArgIntrs, [blInstr, movRetValInstr].compact()].compactAndFlatten()
        case let .returnValue(retVal, _):
            let (retValInstr, retVal) = retVal.armFlexibleOperand
            
            let movRetVal = ARMInstruction.move(condCode: nil,
                                                target: .real(0),
                                                source: retVal)
            
            let popInstr = ARMInstruction.pop(registers: [.real(.framePointer), .real(.programCounter)])
            
            return [retValInstr, [movRetVal, popInstr]].compactAndFlatten()
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
            return [.declareGlobal(label: target.armSymbol)]
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
            let (srcInstr, source) = source.armFlexibleOperand
            
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target.armRegister,
                                               source: source)
            
            return [srcInstr, [movInstr]].compactAndFlatten()
        case let .read(target, _):
            let scanInstructions = ARMInstructionMacros.scanInstructions
            let movRetValInstr = ARMInstruction.move(condCode: nil,
                                                     target: target.armRegister,
                                                     source: .register(.real(0)))
            
            return [scanInstructions, [movRetValInstr]].compactAndFlatten()
        case let .print(source, _):
            let (srcInstr, source) = source.armFlexibleOperand
            let movSrcInstr = ARMInstruction.move(condCode: nil, target: .real(1), source: source)
            let printInstructions = ARMInstructionMacros.printInstructions
            
            return [srcInstr, [movSrcInstr], printInstructions].compactAndFlatten()
    case let .println(source, _):
        let (srcInstr, source) = source.armFlexibleOperand
        let movSrcInstr = ARMInstruction.move(condCode: nil, target: .real(1), source: source)
        let printlnInstructions = ARMInstructionMacros.printlnInstructions
        
        return [srcInstr, [movSrcInstr], printlnInstructions].compactAndFlatten()
        }
    }
}
