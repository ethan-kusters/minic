//
//  Expression+getLLVMInstructions.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

extension Expression {
    func getLLVMInstructions(withContext context: TypeContext, forBlock block: Block, usingSSA ssaEnabled: Bool) -> (instructions: [LLVMInstruction], value: LLVMValue) {
        switch(self) {
        case let .binary(_, op, left, right):
            let (leftInstructions, leftValue) = left.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            let (rightInstructions, rightValue) = right.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            
            let (expInstructions, value) = fromBinaryExpression(binaryOp: op, firstOp: leftValue, secondOp: rightValue)
            
            let instructions = leftInstructions + rightInstructions + expInstructions
            return (instructions, value)
        case let .dot(_, left, id):
            let (leftInstructions, leftValue) = left.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            
            let structTypeDeclaration = left.getStructFromDotExpression(context)
            
            let fieldIndex = structTypeDeclaration.fields.firstIndex(where: {
                $0.name == id
            })!
            
            let fieldType = structTypeDeclaration.fields[fieldIndex].type.llvmType
            
            let getPtrDestReg = LLVMVirtualRegister(ofType: fieldType)
            let getPtrInstruction = LLVMInstruction.getElementPointer(structureType: .structureType(structTypeDeclaration.name),
                                                                      structurePointer: leftValue.identifier,
                                                                      elementIndex: fieldIndex,
                                                                      destination: getPtrDestReg).logRegisterUses()
            
            let ldDestReg = LLVMVirtualRegister(ofType: fieldType)
            let loadInstr = LLVMInstruction.load(source: getPtrDestReg.identifier,
                                                 destination: ldDestReg).logRegisterUses()
            
            return (leftInstructions + [getPtrInstruction, loadInstr], .register(ldDestReg))
        case .false:
            return ([], .literal(LLVMInstructionConstants.falseValue))
        case let .identifier(_, id):
            let identifier = context.getllvmIdentifier(from: id)
            
            if ssaEnabled, case .localValue = identifier {
                let value = block.readVariable(identifier)
                return ([], value)
            } else {
                let destinationRegister = LLVMVirtualRegister(ofType: identifier.type)
                
                let loadInstruction = LLVMInstruction.load(source: identifier,
                                                           destination: destinationRegister).logRegisterUses()
                
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
                let callInstruction = LLVMInstruction.call(functionIdentifier: .function(functionName, retType: returnType),
                                                           arguments: argumentValues,
                                                           destination: nil).logRegisterUses()
                
                instructions.append(callInstruction)
                
                return (instructions, .void)
            } else {
                let returnRegister = LLVMVirtualRegister(ofType: returnType)
                
                let callInstruction = LLVMInstruction.call(functionIdentifier: .function(functionName, retType: returnType),
                                                           arguments: argumentValues,
                                                           destination: returnRegister).logRegisterUses()
                
                instructions.append(callInstruction)
                
                return (instructions, .register(returnRegister))
            }
        case let .new(_, id):
            let numFieldsInType = context.getStruct(id)!.fields.count
            let mallocSize = numFieldsInType * LLVMInstructionConstants.numberOfBytesPerStructField
            
            let mallocDestReg = LLVMVirtualRegister(ofType: .pointer(.i8))
            
            let mallocFuncId = LLVMIdentifier.function(LLVMInstructionConstants.mallocFunction,
                                                       retType: mallocDestReg.type)
            
            let mallocInstr = LLVMInstruction.call(functionIdentifier: mallocFuncId,
                                                   arguments: [.literal(mallocSize)],
                                                   destination: mallocDestReg).logRegisterUses()
            
            let bitCastDestReg = LLVMVirtualRegister(ofType: .structure(name: id))
            
            let bitCastInstr = LLVMInstruction.bitcast(source: .register(mallocDestReg),
                                                       destination: bitCastDestReg).logRegisterUses()
            
            return ([mallocInstr, bitCastInstr], .register(bitCastDestReg))
        case let .null(_, typeIndex):
            return ([], .null(NullTypeManager.getNullType(forIndex: typeIndex).llvmType))
        case .read:
            let destReg = LLVMVirtualRegister.newIntRegister()
            let readFuncId = LLVMIdentifier.function(LLVMInstructionConstants.readHelperFunction,
                                                     retType: destReg.type)
            
            let readInstruction = LLVMInstruction.call(functionIdentifier: readFuncId,
                                                       arguments: [],
                                                       destination: destReg).logRegisterUses()
            
            return ([readInstruction], .register(destReg))
        case .true:
            return ([], .literal(LLVMInstructionConstants.trueValue))
        case let .unary(_, op, operand):
            let (operandInstructions, operandValue) = operand.getLLVMInstructions(withContext: context, forBlock: block, usingSSA: ssaEnabled)
            let (instruction, value) = fromUnaryExpression(unaryOp: op, operand: operandValue)
            
            return (operandInstructions + [instruction], value)
        }
    }
    
    private func fromBinaryExpression(binaryOp: Expression.BinaryOperator,
                                      firstOp: LLVMValue,
                                      secondOp: LLVMValue) -> ([LLVMInstruction], LLVMValue) {
        switch(binaryOp) {
        case .times:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            let multInstr = LLVMInstruction.multiply(firstOp: firstOp,
                                                     secondOp: secondOp,
                                                     destination: destReg).logRegisterUses()
            
            return ([multInstr], .register(destReg))
        case .divide:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            let divInstr = LLVMInstruction.signedDivide(firstOp: firstOp,
                                                        secondOp: secondOp,
                                                        destination: destReg).logRegisterUses()
            
            return ([divInstr], .register(destReg))
        case .plus:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            let addInstr = LLVMInstruction.add(firstOp: firstOp,
                                               secondOp: secondOp,
                                               destination: destReg).logRegisterUses()
            
            return ([addInstr], .register(destReg))
        case .minus:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            let subInstr = LLVMInstruction.subtract(firstOp: firstOp,
                                                    secondOp: secondOp,
                                                    destination: destReg).logRegisterUses()
            
            return ([subInstr], .register(destReg))
        case .lessThan:
            return compareInstruction(condCode: .slt, firstOp: firstOp, secondOp: secondOp)
        case .lessThanOrEqualTo:
            return compareInstruction(condCode: .sle, firstOp: firstOp, secondOp: secondOp)
        case .greaterThan:
            return compareInstruction(condCode: .sgt, firstOp: firstOp, secondOp: secondOp)
        case .greaterThanOrEqualTo:
            return compareInstruction(condCode: .sge, firstOp: firstOp, secondOp: secondOp)
        case .equalTo:
            return compareInstruction(condCode: .eq, firstOp: firstOp, secondOp: secondOp)
        case .notEqualTo:
            return compareInstruction(condCode: .ne, firstOp: firstOp, secondOp: secondOp)
        case .and:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            let andInstr = LLVMInstruction.and(firstOp: firstOp,
                                               secondOp: secondOp,
                                               destination: destReg).logRegisterUses()
            
            return ([andInstr], .register(destReg))
        case .or:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            let orInstr = LLVMInstruction.or(firstOp: firstOp,
                                             secondOp: secondOp,
                                             destination: destReg).logRegisterUses()
            
            return ([orInstr], .register(destReg))
        }
    }
    
    private func compareInstruction(condCode: LLVMConditionCode, firstOp: LLVMValue, secondOp: LLVMValue) -> ([LLVMInstruction], LLVMValue) {
        let cmpDestReg = LLVMVirtualRegister(ofType: .i1)
        let cmpInstr = LLVMInstruction.comparison(condCode: condCode,
                                                  firstOp: firstOp,
                                                  secondOp: secondOp,
                                                  destination: cmpDestReg).logRegisterUses()
        
        let extDestReg = LLVMVirtualRegister.newBoolRegister()
        let extInstr = LLVMInstruction.zeroExtend(source: .register(cmpDestReg),
                                                  destination: extDestReg).logRegisterUses()
        
        return ([cmpInstr, extInstr], .register(extDestReg))
    }
    
    private func fromUnaryExpression(unaryOp: Expression.UnaryOperator, operand: LLVMValue) -> (LLVMInstruction, LLVMValue) {
        switch(unaryOp) {
        case .not:
            let destReg = LLVMVirtualRegister(ofType: operand.type)
            let xorInstr = LLVMInstruction.exclusiveOr(firstOp: operand,
                                                       secondOp: .literal(LLVMInstructionConstants.trueValue),
                                                       destination: destReg).logRegisterUses()
            
            return (xorInstr, .register(destReg))
        case .minus:
            let destReg = LLVMVirtualRegister(ofType: operand.type)
            let subInstr = LLVMInstruction.subtract(firstOp: .literal(0),
                                                    secondOp: operand,
                                                    destination: destReg).logRegisterUses()
            
            return (subInstr, .register(destReg))
        }
    }
}
