//
//  Expression+getLLVMInstructions.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

extension Expression {
    func getLLVMInstructions(withContext context: TypeContext,
                             forBlock block: LLVMInstructionBlock,
                             usingSSA ssaEnabled: Bool) -> (instructions: [LLVMInstruction], value: LLVMValue) {
        switch(self) {
        case let .binary(_, op, left, right):
            let (leftInstructions, leftValue) = left.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            let (rightInstructions, rightValue) = right.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            
            let (expInstructions, value) = fromBinaryExpression(binaryOp: op,
                                                                firstOp: leftValue,
                                                                secondOp: rightValue,
                                                                block: block)
            
            let instructions = leftInstructions + rightInstructions + expInstructions
            return (instructions, value)
        case let .dot(_, left, id):
            let (leftInstructions, leftValue) = left.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            
            let structTypeDeclaration = left.getStructFromDotExpression(context)
            
            let fieldIndex = structTypeDeclaration.fields.firstIndex(where: {
                $0.name == id
            })!
            
            let fieldType = structTypeDeclaration.fields[fieldIndex].type.llvmType
            
            let getPtrTargetReg = LLVMVirtualRegister(ofType: fieldType)
            let getPtrInstruction = LLVMInstruction.getElementPointer(target: getPtrTargetReg,
                                                                      structureType: .structureType(structTypeDeclaration.name),
                                                                      structurePointer: leftValue.identifier,
                                                                      elementIndex: fieldIndex,
                                                                      block: block).logRegisterUses()
            
            let ldTargetReg = LLVMVirtualRegister(ofType: fieldType)
            let loadInstr = LLVMInstruction.load(target: ldTargetReg,
                                                 srcPointer: getPtrTargetReg.identifier,
                                                 block: block).logRegisterUses()
            
            return (leftInstructions + [getPtrInstruction, loadInstr], .register(ldTargetReg))
        case .false:
            return ([], .literal(LLVMInstructionConstants.falseValue))
        case let .identifier(_, id):
            let identifier = context.getllvmIdentifier(from: id)
            
            if ssaEnabled, case .virtualRegister = identifier {
                let value = block.readVariable(identifier)
                return ([], value)
            } else {
                let destinationRegister = LLVMVirtualRegister(ofType: identifier.type)
                
                let loadInstruction = LLVMInstruction.load(target: destinationRegister,
                                                           srcPointer: identifier,
                                                           block: block).logRegisterUses()
                
                return ([loadInstruction], .register(destinationRegister))
            }
        case let .integer(_, value):
            return ([], .literal(value))
        case let .invocation(_, functionName, arguments):
            var instructions = [LLVMInstruction]()
            
            let argumentValues = arguments.map { expression -> LLVMValue in
                let (newInstructions, newValue) = expression.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
                instructions.append(contentsOf: newInstructions)
                return newValue
            }
            
            let returnType = context.getFunction(functionName)!.retType.llvmType
            
            if returnType == .void {
                let callInstruction = LLVMInstruction.call(target: nil,
                                                           functionIdentifier: .function(functionName, retType: returnType),
                                                           arguments: argumentValues,
                                                           block: block).logRegisterUses()
                
                instructions.append(callInstruction)
                
                return (instructions, .void)
            } else {
                let returnRegister = LLVMVirtualRegister(ofType: returnType)
                
                let callInstruction = LLVMInstruction.call(target: returnRegister,
                                                           functionIdentifier: .function(functionName, retType: returnType),
                                                           arguments: argumentValues,
                                                           block: block).logRegisterUses()
                
                instructions.append(callInstruction)
                
                return (instructions, .register(returnRegister))
            }
        case let .new(_, id):
            let numFieldsInType = context.getStruct(id)!.fields.count
            let mallocSize = numFieldsInType * LLVMInstructionConstants.numberOfBytesPerStructField
            
            let mallocTargetReg = LLVMVirtualRegister(ofType: .pointer(.i8))
            
            let mallocFuncId = LLVMIdentifier.function(LLVMInstructionConstants.mallocFunction,
                                                       retType: mallocTargetReg.type)
            
            let mallocInstr = LLVMInstruction.call(target: mallocTargetReg,
                                                   functionIdentifier: mallocFuncId,
                                                   arguments: [.literal(mallocSize)],
                                                   block: block).logRegisterUses()
            
            let bitCastTargetReg = LLVMVirtualRegister(ofType: .structure(name: id))
            
            let bitCastInstr = LLVMInstruction.bitcast(target: bitCastTargetReg,
                                                       source: .register(mallocTargetReg),
                                                       block: block).logRegisterUses()
            
            return ([mallocInstr, bitCastInstr], .register(bitCastTargetReg))
        case let .null(_, typeIndex):
            return ([], .null(NullTypeManager.getNullType(forIndex: typeIndex).llvmType))
        case .read:
            let targetReg = LLVMVirtualRegister.newIntRegister()
            let readInstruction = LLVMInstruction.read(target: targetReg,
                                                       block: block).logRegisterUses()
            
            return ([readInstruction], .register(targetReg))
        case .true:
            return ([], .literal(LLVMInstructionConstants.trueValue))
        case let .unary(_, op, operand):
            let (operandInstructions, operandValue) = operand.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            let (instruction, value) = fromUnaryExpression(unaryOp: op, operand: operandValue, block: block)
            
            return (operandInstructions + [instruction], value)
        }
    }
    
    private func fromBinaryExpression(binaryOp: Expression.BinaryOperator,
                                      firstOp: LLVMValue,
                                      secondOp: LLVMValue,
                                      block: LLVMInstructionBlock) -> ([LLVMInstruction], LLVMValue) {
        switch(binaryOp) {
        case .times:
            let targetReg = LLVMVirtualRegister(ofType: firstOp.type)
            let multInstr = LLVMInstruction.multiply(target: targetReg,
                                                     firstOp: firstOp,
                                                     secondOp: secondOp,
                                                     block: block).logRegisterUses()
            
            return ([multInstr], .register(targetReg))
        case .divide:
            let targetReg = LLVMVirtualRegister(ofType: firstOp.type)
            let divInstr = LLVMInstruction.signedDivide(target: targetReg,
                                                        firstOp: firstOp,
                                                        secondOp: secondOp,
                                                        block: block).logRegisterUses()
            
            return ([divInstr], .register(targetReg))
        case .plus:
            let targetReg = LLVMVirtualRegister(ofType: firstOp.type)
            let addInstr = LLVMInstruction.add(target: targetReg,
                                               firstOp: firstOp,
                                               secondOp: secondOp,
                                               block: block).logRegisterUses()
            
            return ([addInstr], .register(targetReg))
        case .minus:
            let targetReg = LLVMVirtualRegister(ofType: firstOp.type)
            let subInstr = LLVMInstruction.subtract(target: targetReg,
                                                    firstOp: firstOp,
                                                    secondOp: secondOp,
                                                    block: block).logRegisterUses()
            
            return ([subInstr], .register(targetReg))
        case .lessThan:
            return compareInstruction(condCode: .slt, firstOp: firstOp, secondOp: secondOp, block: block)
        case .lessThanOrEqualTo:
            return compareInstruction(condCode: .sle, firstOp: firstOp, secondOp: secondOp, block: block)
        case .greaterThan:
            return compareInstruction(condCode: .sgt, firstOp: firstOp, secondOp: secondOp, block: block)
        case .greaterThanOrEqualTo:
            return compareInstruction(condCode: .sge, firstOp: firstOp, secondOp: secondOp, block: block)
        case .equalTo:
            return compareInstruction(condCode: .eq, firstOp: firstOp, secondOp: secondOp, block: block)
        case .notEqualTo:
            return compareInstruction(condCode: .ne, firstOp: firstOp, secondOp: secondOp, block: block)
        case .and:
            let targetReg = LLVMVirtualRegister(ofType: firstOp.type)
            let andInstr = LLVMInstruction.and(target: targetReg,
                                               firstOp: firstOp,
                                               secondOp: secondOp,
                                               block: block).logRegisterUses()
            
            return ([andInstr], .register(targetReg))
        case .or:
            let targetReg = LLVMVirtualRegister(ofType: firstOp.type)
            let orInstr = LLVMInstruction.or(target: targetReg,
                                             firstOp: firstOp,
                                             secondOp: secondOp,
                                             block: block).logRegisterUses()
            
            return ([orInstr], .register(targetReg))
        }
    }
    
    private func compareInstruction(condCode: LLVMConditionCode, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock) -> ([LLVMInstruction], LLVMValue) {
        let cmpTargetReg = LLVMVirtualRegister(ofType: .i1)
        let cmpInstr = LLVMInstruction.comparison(target: cmpTargetReg,
                                                  condCode: condCode,
                                                  firstOp: firstOp,
                                                  secondOp: secondOp,
                                                  block: block).logRegisterUses()
        

        return ([cmpInstr], .register(cmpTargetReg))
    }
    
    private func fromUnaryExpression(unaryOp: Expression.UnaryOperator, operand: LLVMValue, block: LLVMInstructionBlock) -> (LLVMInstruction, LLVMValue) {
        switch(unaryOp) {
        case .not:
            let targetReg = LLVMVirtualRegister(ofType: operand.type)
            let xorInstr = LLVMInstruction.exclusiveOr(target: targetReg,
                                                       firstOp: operand,
                                                       secondOp: .literal(LLVMInstructionConstants.trueValue),
                                                       block: block).logRegisterUses()
            
            return (xorInstr, .register(targetReg))
        case .minus:
            let targetReg = LLVMVirtualRegister(ofType: operand.type)
            let subInstr = LLVMInstruction.subtract(target: targetReg,
                                                    firstOp: .literal(0),
                                                    secondOp: operand,
                                                    block: block).logRegisterUses()
            
            return (subInstr, .register(targetReg))
        }
    }
}
