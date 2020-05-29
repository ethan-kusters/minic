//
//  LLVMInstruction+armInstructions.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMInstruction {
    func getArmInstructions(withContext context: CodeGenerationContext) -> [ARMInstruction] {
        switch(self) {
        case let .add(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let addInstr = ARMInstruction.add(target: target.getARMRegister(context),
                                              firstOp: firstOp,
                                              secondOp: secondOp).logRegisterUses()
            
            return [firstOpInstr, secondOpInstr, [addInstr]].compactAndFlatten()
        case let .subtract(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let subInstr = ARMInstruction.subtract(target: target.getARMRegister(context),
                                                   firstOp: firstOp,
                                                   secondOp: secondOp).logRegisterUses()
            
            return [firstOpInstr, secondOpInstr, [subInstr]].compactAndFlatten()
        case let .multiply(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getARMRegister(context)
            
            let multInstr = ARMInstruction.multiply(target: target.getARMRegister(context),
                                                    firstOp: firstOp,
                                                    secondOp: secondOp).logRegisterUses()
            
            return [firstOpInstr, secondOpInstr, [multInstr]].compactAndFlatten()
        case let .signedDivide(target, firstOp, secondOp, _):
            /// Signed divide isn't supported on older ARM CPUs so we
            /// call a library function.
            
            let r0 = context.getRegister(fromRealRegister: 0)
            let r1 = context.getRegister(fromRealRegister: 1)
            
            let firstOpInstr = firstOp.moveToRegister(context, target: r0)
            let secondOpInstr = secondOp.moveToRegister(context, target: r1)
            
            let divCall = ARMInstruction.branchWithLink(label: ARMInstructionStringConstants.divideFunctionSymbol).logRegisterUses()
            
            let movRetVal = ARMInstruction.move(condCode: nil,
                                                target: target.getARMRegister(context),
                                                source: r0.flexibleOperand).logRegisterUses()
            
            return [firstOpInstr, secondOpInstr, [divCall, movRetVal]].compactAndFlatten()
        case let .and(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let andInstr = ARMInstruction.and(target: target.getARMRegister(context),
                                              firstOp: firstOp,
                                              secondOp: secondOp).logRegisterUses()
            
            return [firstOpInstr, secondOpInstr, [andInstr]].compactAndFlatten()
        case let .or(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let orInstr = ARMInstruction.or(target: target.getARMRegister(context),
                                            firstOp: firstOp,
                                            secondOp: secondOp).logRegisterUses()
            
            return [firstOpInstr, secondOpInstr, [orInstr]].compactAndFlatten()
        case let .exclusiveOr(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let xorInstr = ARMInstruction.exclusiveOr(target: target.getARMRegister(context),
                                                      firstOp: firstOp,
                                                      secondOp: secondOp).logRegisterUses()
            
            return [firstOpInstr, secondOpInstr, [xorInstr]].compactAndFlatten()
        case let .comparison(target, condCode, firstOp, secondOp, _):
            let assumeFalseInstr = ARMInstruction.move(condCode: nil,
                                                       target: target.getARMRegister(context),
                                                       source: .constant(ARMInstructionConstants.falseValue)).logRegisterUses()
            
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let cmpInstr = ARMInstruction.compare(firstOp: firstOp,
                                                  secondOp: secondOp).logRegisterUses()
            
            let condMovInstr = ARMInstruction.move(condCode: condCode.armConditionCode,
                                                   target: target.getARMRegister(context),
                                                   source: .constant(ARMInstructionConstants.trueValue)).logRegisterUses()
            
            target.getARMRegister(context).addUse(condMovInstr)
            
            return [[assumeFalseInstr], firstOpInstr, secondOpInstr, [cmpInstr, condMovInstr]].compactAndFlatten()
        case let .conditionalBranch(conditional, ifTrue, ifFalse, _):
            let (condInstr, condReg) = conditional.getARMRegister(context)
            
            let cmpInstr = ARMInstruction.compare(firstOp: condReg,
                                                  secondOp: .constant(ARMInstructionConstants.trueValue)).logRegisterUses()
            
            let ifTrueBranch = ARMInstruction.branch(condCode: .EQ,
                                                     label: ifTrue.armSymbol).logRegisterUses()
            
            let ifFalseBranch = ARMInstruction.branch(condCode: nil,
                                                      label: ifFalse.armSymbol).logRegisterUses()
            
            return [condInstr, [cmpInstr, ifTrueBranch, ifFalseBranch]].compactAndFlatten()
        case let .unconditionalBranch(destLabel, _):
            let brInstr = ARMInstruction.branch(condCode: nil, label: destLabel.armSymbol)
            
            return [brInstr]
        case let .load(target, srcPointer, _):
            let (srcInstr, srcReg) = srcPointer.getARMRegister(context)
            
            let ldInstr = ARMInstruction.load(target: target.getARMRegister(context),
                                              sourceAddress: srcReg).logRegisterUses()
            
            return [srcInstr, [ldInstr]].compactAndFlatten()
        case let .store(source, destPointer, _):
            let (srcInstr, srcReg) = source.getARMRegister(context)
            let (trgInstr, trgRrg) = destPointer.getARMRegister(context)
            
            let storeInstruction = ARMInstruction.store(source: srcReg,
                                                        targetAddress: trgRrg).logRegisterUses()
            
            return [srcInstr, trgInstr, [storeInstruction]].compactAndFlatten()
        case let .getElementPointer(target, _, structurePointer, elementIndex, _):
            let (ptrInstr, ptrReg) = structurePointer.getARMRegister(context)
            
            
            let offset = elementIndex * ARMInstructionConstants.bytesPerValue
            
            let addInstr = ARMInstruction.add(target: target.getARMRegister(context),
                                              firstOp: ptrReg,
                                              secondOp: .constant(offset.immediateValue)).logRegisterUses()
            
            return [ptrInstr, [addInstr]].compactAndFlatten()
        case let .call(target, functionIdentifier, arguments, _):
            let movArgIntrs = arguments.enumerated().flatMap { (index, argument) -> [ARMInstruction] in
                guard index < 3 else { fatalError("ToDo: Add support for >3 args")}
                
                let (srcInstr, srcOp) = argument.getFlexibleOperand(context)
                
                let movInstr = ARMInstruction.move(condCode: nil,
                                                   target: index.getARMRegister(context),
                                                   source: srcOp).logRegisterUses()
                
                return [srcInstr, [movInstr]].compactAndFlatten()
            }
            
            let blInstr = ARMInstruction.branchWithLink(label: functionIdentifier.armSymbol)
            
            var movRetValInstr: ARMInstruction?
            if let target = target {
                let r0 = context.getRegister(fromRealRegister: 0)
                
                movRetValInstr = ARMInstruction.move(condCode: nil,
                                       target: target.getARMRegister(context),
                                       source: r0.flexibleOperand).logRegisterUses()
            }
            
            return [movArgIntrs, [blInstr, movRetValInstr].compact()].compactAndFlatten()
        case let .returnValue(retVal, _):
            let r0 = context.getRegister(fromRealRegister: 0)
//            let fp = context.getRegister(fromRealRegister: .framePointer)
//            let pc = context.getRegister(fromRealRegister: .programCounter)
            
            let (retValInstr, retVal) = retVal.getFlexibleOperand(context)
            
            let movRetVal = ARMInstruction.move(condCode: nil,
                                                target: r0,
                                                source: retVal).logRegisterUses()
            
//            let popInstr = ARMInstruction.pop(registers: [fp, pc]).logRegisterUses()
            
            return [retValInstr, [movRetVal]].compactAndFlatten()
        case .returnVoid:
//            let fp = context.getRegister(fromRealRegister: .framePointer)
//            let pc = context.getRegister(fromRealRegister: .programCounter)
//            let popInstr = ARMInstruction.pop(registers: [fp, pc]).logRegisterUses()
            
            return []
        case let .allocate(target, _):
            let sp = context.getRegister(fromRealRegister: .stackPointer)
            
            let spSubInstr = ARMInstruction.subtract(target: sp,
                                                     firstOp: sp,
                                                     secondOp: .constant(ARMInstructionConstants.bytesPerValue.immediateValue)).logRegisterUses()
            
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target.getARMRegister(context),
                                               source: sp.flexibleOperand).logRegisterUses()
            
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
            let (srcInstr, source) = source.getFlexibleOperand(context)
            
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target.getARMRegister(context),
                                               source: source).logRegisterUses()
            
            return [srcInstr, [movInstr]].compactAndFlatten()
        case let .read(target, _):
            let scanInstructions = ARMInstructionMacros.getScanInstructions(context)
            let movRetAddrInstr = ARMInstructionMacros.getMoveSymbol32(target: target.getARMRegister(context),
                                                                       source: ARMInstructionStringConstants.readScratchVariableSymbol)
            
            let loadRetValInstr = ARMInstruction.load(target: target.getARMRegister(context),
                                                      sourceAddress: target.getARMRegister(context)).logRegisterUses()
            
            return [scanInstructions, movRetAddrInstr, [loadRetValInstr]].compactAndFlatten()
        case let .print(source, _):
            let r1 = context.getRegister(fromRealRegister: 1)
            
            let (srcInstr, source) = source.getFlexibleOperand(context)
            let movSrcInstr = ARMInstruction.move(condCode: nil, target: r1, source: source)
            let printInstructions = ARMInstructionMacros.getPrintInstructions(context)
            
            return [srcInstr, [movSrcInstr], printInstructions].compactAndFlatten()
        case let .println(source, _):
            let r1 = context.getRegister(fromRealRegister: 1)
            
            let (srcInstr, source) = source.getFlexibleOperand(context)
            let movSrcInstr = ARMInstruction.move(condCode: nil, target: r1, source: source)
            let printlnInstructions = ARMInstructionMacros.getPrintlnInstructions(context)
            
            return [srcInstr, [movSrcInstr], printlnInstructions].compactAndFlatten()
        }
    }
}
