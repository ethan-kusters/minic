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
                                              secondOp: secondOp).logRegisterUses(context)
            
            return [firstOpInstr, secondOpInstr, [addInstr]].compactAndFlatten()
        case let .subtract(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let subInstr = ARMInstruction.subtract(target: target.getARMRegister(context),
                                                   firstOp: firstOp,
                                                   secondOp: secondOp).logRegisterUses(context)
            
            return [firstOpInstr, secondOpInstr, [subInstr]].compactAndFlatten()
        case let .multiply(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getARMRegister(context)
            
            let multInstr = ARMInstruction.multiply(target: target.getARMRegister(context),
                                                    firstOp: firstOp,
                                                    secondOp: secondOp).logRegisterUses(context)
            
            return [firstOpInstr, secondOpInstr, [multInstr]].compactAndFlatten()
        case let .signedDivide(target, firstOp, secondOp, _):
            /// Signed divide isn't supported on older ARM CPUs so we
            /// call a library function.
            
            let r0 = context.getRegister(fromRealRegister: 0)
            let r1 = context.getRegister(fromRealRegister: 1)
            
            let firstOpInstr = firstOp.moveToRegister(context, target: r0)
            let secondOpInstr = secondOp.moveToRegister(context, target: r1)
            
            let divCall = ARMInstruction.branchWithLink(label: ARMInstructionStringConstants.divideFunctionSymbol,
                                                        arguments: [r0, r1]).logRegisterUses(context)
            
            let movRetVal = ARMInstruction.move(condCode: nil,
                                                target: target.getARMRegister(context),
                                                source: r0.flexibleOperand).logRegisterUses(context)
            
            return [firstOpInstr, secondOpInstr, [divCall, movRetVal]].compactAndFlatten()
        case let .and(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let andInstr = ARMInstruction.and(target: target.getARMRegister(context),
                                              firstOp: firstOp,
                                              secondOp: secondOp).logRegisterUses(context)
            
            return [firstOpInstr, secondOpInstr, [andInstr]].compactAndFlatten()
        case let .or(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let orInstr = ARMInstruction.or(target: target.getARMRegister(context),
                                            firstOp: firstOp,
                                            secondOp: secondOp).logRegisterUses(context)
            
            return [firstOpInstr, secondOpInstr, [orInstr]].compactAndFlatten()
        case let .exclusiveOr(target, firstOp, secondOp, _):
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let xorInstr = ARMInstruction.exclusiveOr(target: target.getARMRegister(context),
                                                      firstOp: firstOp,
                                                      secondOp: secondOp).logRegisterUses(context)
            
            return [firstOpInstr, secondOpInstr, [xorInstr]].compactAndFlatten()
        case let .comparison(target, condCode, firstOp, secondOp, _):
            let assumeFalseInstr = ARMInstruction.move(condCode: nil,
                                                       target: target.getARMRegister(context),
                                                       source: .constant(ARMInstructionConstants.falseValue)).logRegisterUses(context)
            
            let (firstOpInstr, firstOp) = firstOp.getARMRegister(context)
            let (secondOpInstr, secondOp) = secondOp.getFlexibleOperand(context)
            
            let cmpInstr = ARMInstruction.compare(firstOp: firstOp,
                                                  secondOp: secondOp).logRegisterUses(context)
            
            let condMovInstr = ARMInstruction.move(condCode: condCode.armConditionCode,
                                                   target: target.getARMRegister(context),
                                                   source: .constant(ARMInstructionConstants.trueValue)).logRegisterUses(context)
            
            target.getARMRegister(context).addUse(condMovInstr)
            
            return [[assumeFalseInstr], firstOpInstr, secondOpInstr, [cmpInstr, condMovInstr]].compactAndFlatten()
        case let .conditionalBranch(conditional, ifTrue, ifFalse, _):
            let (condInstr, condReg) = conditional.getARMRegister(context)
            
            let cmpInstr = ARMInstruction.compare(firstOp: condReg,
                                                  secondOp: .constant(ARMInstructionConstants.trueValue)).logRegisterUses(context)
            
            let ifTrueBranch = ARMInstruction.branch(condCode: .EQ,
                                                     label: ifTrue.llvmIdentifier.armSymbol).logRegisterUses(context)
            
            let ifFalseBranch = ARMInstruction.branch(condCode: nil,
                                                      label: ifFalse.llvmIdentifier.armSymbol).logRegisterUses(context)
            
            return [condInstr, [cmpInstr, ifTrueBranch, ifFalseBranch]].compactAndFlatten()
        case let .unconditionalBranch(destLabel, _):
            let brInstr = ARMInstruction.branch(condCode: nil, label: destLabel.llvmIdentifier.armSymbol)
            
            return [brInstr]
        case let .load(target, srcPointer, _):
            let (srcInstr, srcReg) = srcPointer.getARMRegisterForPointer(context)
            
            let ldInstr = ARMInstruction.load(target: target.getARMRegister(context),
                                              sourceAddress: srcReg).logRegisterUses(context)
            
            return [srcInstr, [ldInstr]].compactAndFlatten()
        case let .store(source, destPointer, _):
            let (srcInstr, srcReg) = source.getARMRegister(context)
            let (trgInstr, trgRrg) = destPointer.getARMRegisterForPointer(context)
            
            let storeInstruction = ARMInstruction.store(source: srcReg,
                                                        targetAddress: trgRrg).logRegisterUses(context)
            
            return [srcInstr, trgInstr, [storeInstruction]].compactAndFlatten()
        case let .getElementPointer(target, _, structurePointer, elementIndex, _):
            let (ptrInstr, ptrReg) = structurePointer.getARMRegister(context)
            
            
            let offset = elementIndex * ARMInstructionConstants.bytesPerValue
            
            let addInstr = ARMInstruction.add(target: target.getARMRegister(context),
                                              firstOp: ptrReg,
                                              secondOp: .constant(offset.immediateValue)).logRegisterUses(context)
            
            return [ptrInstr, [addInstr]].compactAndFlatten()
        case let .call(target, functionIdentifier, arguments, _):
            var argumentRegisters = [ARMRegister]()
            context.setMaxNumOfArgsOnStack(arguments.count - 4)
            
            let movAndStrArgIntrs = arguments.enumerated().flatMap { (index, argument) -> [ARMInstruction] in
                if index < 4 {
                    let (srcInstr, srcOp) = argument.getFlexibleOperand(context)
                    
                    let argReg = index.getARMRegister(context)
                    argumentRegisters.append(argReg)
                    
                    let movInstr = ARMInstruction.move(condCode: nil,
                                                       target: argReg,
                                                       source: srcOp).logRegisterUses(context)
                    
                    return [srcInstr, [movInstr]].compactAndFlatten()
                } else {
                    let (srcInstr, srcReg) = argument.getARMRegister(context)
                    let offset = (index - 4) * ARMInstructionConstants.bytesPerValue
                    
                    let sp = context.getRegister(fromRealRegister: .stackPointer)
                    let strInstr = ARMInstruction.store(source: srcReg,
                                                                targetAddress: sp,
                                                                offset: offset.immediateValue)
                    
                    return [srcInstr, [strInstr]].compactAndFlatten()
                }
            }
            
            
            let blInstr = ARMInstruction.branchWithLink(label: functionIdentifier.armSymbol,
                                                        arguments: argumentRegisters)
            
            var movRetValInstr: ARMInstruction?
            if let target = target {
                let r0 = context.getRegister(fromRealRegister: 0)
                
                movRetValInstr = ARMInstruction.move(condCode: nil,
                                       target: target.getARMRegister(context),
                                       source: r0.flexibleOperand).logRegisterUses(context)
            }
            
            return [movAndStrArgIntrs, [blInstr, movRetValInstr].compact()].compactAndFlatten()
        case let .returnValue(retVal, _):
            let r0 = context.getRegister(fromRealRegister: 0)
            
            let (retValInstr, retVal) = retVal.getFlexibleOperand(context)
            
            let movRetVal = ARMInstruction.move(condCode: nil,
                                                target: r0,
                                                source: retVal).logRegisterUses(context)
            
            return [retValInstr, [movRetVal]].compactAndFlatten()
        case .returnVoid:
            return []
        case let .allocate(target, _):
            let fp = context.getRegister(fromRealRegister: .framePointer)
            let addInstr = ARMInstruction.subtract(target: target.getARMRegister(context),
                                                   firstOp: fp,
                                                   secondOp: .constant(context.getNextLocalAddressOffset()))
            
            return [addInstr]
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
            let target = target.getARMRegister(context)
            
            guard target != source else { return [] }
            
            let movInstr = ARMInstruction.move(condCode: nil,
                                               target: target,
                                               source: source).logRegisterUses(context)
            
            return [srcInstr, [movInstr]].compactAndFlatten()
        case let .read(target, _):
            let scanInstructions = ARMInstructionMacros.getScanInstructions(context)
            let movRetAddrInstr = ARMInstructionMacros.getMoveSymbol32(context,
                                                                       target: target.getARMRegister(context),
                                                                       source: ARMInstructionStringConstants.readScratchVariableSymbol)
            
            let loadRetValInstr = ARMInstruction.load(target: target.getARMRegister(context),
                                                      sourceAddress: target.getARMRegister(context)).logRegisterUses(context)
            
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
