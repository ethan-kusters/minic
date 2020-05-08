//
//  Expression+getLLVMInstructions.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

extension Expression {
    func getLLVMInstructions(_ context: TypeContext) -> (instructions: [LLVMInstruction], value: LLVMValue) {
        switch(self) {
        case let .binary(_, op, left, right):
            let (leftInstructions, leftValue) = left.getLLVMInstructions(context)
            let (rightInstructions, rightValue) = right.getLLVMInstructions(context)
            
            let (expInstructions, value) = fromBinaryExpression(binaryOp: op, firstOp: leftValue, secondOp: rightValue)
            
            let instructions = leftInstructions + rightInstructions + expInstructions
            return (instructions, value)
        case let .dot(_, left, id):
            let (leftInstructions, leftValue) = left.getLLVMInstructions(context)
            
            let structTypeDeclaration = left.getStructFromDotExpression(context)
            
            let fieldIndex = structTypeDeclaration.fields.firstIndex(where: {
                $0.name == id
            })!
            
            let fieldType = structTypeDeclaration.fields[fieldIndex].type.llvmType
            
            let getPtrDestReg = LLVMVirtualRegister(ofType: fieldType)
            let getPtrInstruction = LLVMInstruction.getElementPointer(structureType: .structureType(structTypeDeclaration.name),
                                                                      structurePointer: leftValue.identifier,
                                                                      elementIndex: fieldIndex,
                                                                      destination: getPtrDestReg.identifier)
            
            let ldDestReg = LLVMVirtualRegister(ofType: fieldType)
            let loadInstr = LLVMInstruction.load(source: getPtrDestReg.identifier,
                                                 destination: ldDestReg.identifier)
            
            return (leftInstructions + [getPtrInstruction, loadInstr], .register(ldDestReg))
        case .false:
            return ([], .literal(LLVMInstructionConstants.falseValue))
        case let .identifier(_, id):
            let pointerVal = context.getllvmIdentifier(from: id)
            let destinationRegister = LLVMVirtualRegister(ofType: pointerVal.type)
            
            let loadInstruction = LLVMInstruction.load(source: pointerVal,
                                                       destination: destinationRegister.identifier)
            
            return ([loadInstruction], .register(destinationRegister))
        case let .integer(_, value):
            return ([], .literal(value))
        case let .invocation(_, functionName, arguments):
            var instructions = [LLVMInstruction]()
            
            let argumentValues = arguments.map { expression -> LLVMValue in
                let (newInstructions, newValue) = expression.getLLVMInstructions(context)
                instructions.append(contentsOf: newInstructions)
                return newValue
            }
            
            let returnType = context.getFunction(functionName)!.retType.llvmType
            
            if returnType == .void {
                let callInstruction = LLVMInstruction.call(returnType: returnType,
                                                           functionPointer: .function(functionName, retType: returnType),
                                                           arguments: argumentValues,
                                                           destination: nil)
                
                instructions.append(callInstruction)
                
                return (instructions, .void)
            } else {
                let returnRegister = LLVMVirtualRegister(ofType: returnType)
                
                let callInstruction = LLVMInstruction.call(returnType: returnType,
                                                           functionPointer: .function(functionName, retType: returnType),
                                                           arguments: argumentValues,
                                                           destination: returnRegister.identifier)
                
                instructions.append(callInstruction)
                
                return (instructions, .register(returnRegister))
            }
        case let .new(_, id):
            let numFieldsInType = context.getStruct(id)!.fields.count
            
            let mallocDestReg = LLVMVirtualRegister(ofType: .pointer(.i8))
            let mallocInstr = LLVMInstruction.call(returnType: mallocDestReg.type,
                                               functionPointer: .function(LLVMInstructionConstants.mallocFunction,
                                                                          retType: mallocDestReg.type),
                                               arguments: [.literal(numFieldsInType * LLVMInstructionConstants.numberOfBytesPerStructField)],
                                               destination: mallocDestReg.identifier)
            
            let bitCastDestReg = LLVMVirtualRegister(ofType: .structure(name: id))
            
            let bitCastInstr = LLVMInstruction.bitcast(source: mallocDestReg.identifier,
                                                       destination: bitCastDestReg.identifier)
            
            return ([mallocInstr, bitCastInstr], .register(bitCastDestReg))
        case let .null(_, typeIndex):
            return ([], .null(NullTypeManager.getNullType(forIndex: typeIndex).llvmType))
        case .read:
            let destReg = LLVMVirtualRegister.newIntRegister()
            let readInstruction = LLVMInstruction.call(returnType: destReg.type,
                                                   functionPointer: .function(LLVMInstructionConstants.readHelperFunction,
                                                                              retType: destReg.type),
                                                   arguments: [],
                                                   destination: destReg.identifier)
            
            return ([readInstruction], .register(destReg))
        case .true:
            return ([], .literal(LLVMInstructionConstants.trueValue))
        case let .unary(_, op, operand):
            let (operandInstructions, operandValue) = operand.getLLVMInstructions(context)
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
            return ([.multiply(firstOp: firstOp, secondOp: secondOp, destination: destReg.identifier)], .register(destReg))
        case .divide:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            return ([.signedDivide(firstOp: firstOp, secondOp: secondOp, destination: destReg.identifier)], .register(destReg))
        case .plus:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            return ([.add(firstOp: firstOp, secondOp: secondOp, destination: destReg.identifier)], .register(destReg))
        case .minus:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            return ([.subtract(firstOp: firstOp, secondOp: secondOp, destination: destReg.identifier)], .register(destReg))
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
            return ([.and(firstOp: firstOp, secondOp: secondOp, destination: destReg.identifier)], .register(destReg))
        case .or:
            let destReg = LLVMVirtualRegister(ofType: firstOp.type)
            return ([.or(firstOp: firstOp, secondOp: secondOp, destination: destReg.identifier)], .register(destReg))
        }
    }
    
    private func compareInstruction(condCode: LLVMConditionCode, firstOp: LLVMValue, secondOp: LLVMValue) -> ([LLVMInstruction], LLVMValue) {
        let cmpDestReg = LLVMVirtualRegister(ofType: .i1)
        let comp = LLVMInstruction.comparison(condCode: condCode, firstOp: firstOp, secondOp: secondOp, destination: cmpDestReg.identifier)
        
        let extDestReg = LLVMVirtualRegister.newBoolRegister()
        let ext = LLVMInstruction.zeroExtend(source: cmpDestReg.identifier, destination: extDestReg.identifier)
        return ([comp, ext], .register(extDestReg))
    }
    
    private func fromUnaryExpression(unaryOp: Expression.UnaryOperator, operand: LLVMValue) -> (LLVMInstruction, LLVMValue) {
        switch(unaryOp) {
        case .not:
            let destReg = LLVMVirtualRegister(ofType: operand.type)
            let xorInstr = LLVMInstruction.exclusiveOr(firstOp: operand,
                                                       secondOp: .literal(LLVMInstructionConstants.trueValue),
                                                       destination: destReg.identifier)
            
            return (xorInstr, .register(destReg))
        case .minus:
            let destReg = LLVMVirtualRegister(ofType: operand.type)
            let subInstr = LLVMInstruction.subtract(firstOp: .literal(0),
                                                    secondOp: operand,
                                                    destination: destReg.identifier)
            
            return (subInstr, .register(destReg))
        }
    }
}
