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
            
            let ptrResult = LLVMValue.newRegister(forType: fieldType)
            let getPtrInstruction = LLVMInstruction.getElementPointer(structureType: .structureType(structTypeDeclaration.name),
                                                                  structurePointer: leftValue,
                                                                  elementIndex: fieldIndex,
                                                                  result: ptrResult)
            
            let ldResult = LLVMValue.newRegister(forType: fieldType)
            let loadInstr = LLVMInstruction.load(source: .localValue(ptrResult.identifier, type: ptrResult.type),
                                             destination: ldResult)
            
            return (leftInstructions + [getPtrInstruction, loadInstr], ldResult)
        case .false:
            return ([], .literal(LLVMInstructionConstants.falseValue))
        case let .identifier(_, id):
            let pointerVal = context.getllvmIdentifier(from: id)
            let destinationRegister = LLVMValue.newRegister(forType: pointerVal.type)
            
            let loadInstruction = LLVMInstruction.load(source: pointerVal,
                                                   destination: destinationRegister)
            
            return ([loadInstruction], destinationRegister)
        case let .integer(_, value):
            return ([], .literal(value))
        case let .invocation(_, name, arguments):
            var instructions = [LLVMInstruction]()
            
            let argumentValues = arguments.map { expression -> LLVMValue in
                let (newInstructions, newValue) = expression.getLLVMInstructions(context)
                instructions.append(contentsOf: newInstructions)
                return newValue
            }
            
            let returnType = context.getFunction(name)!.retType.llvmType
            
            let returnRegister = LLVMValue.newRegister(forType: returnType)
            
            let callInstruction = LLVMInstruction.call(returnType: returnType,
                                                   functionPointer: .function(name, retType: returnType),
                                                   arguments: argumentValues,
                                                   result: returnType == .void ? nil : returnRegister)
            
            instructions.append(callInstruction)
            
            return (instructions, returnRegister)
        case let .new(_, id):
            let numFieldsInType = context.getStruct(id)!.fields.count
            
            let tempReg = LLVMValue.newRegister(forType: .pointer(.i8))
            let mallocInstr = LLVMInstruction.call(returnType: tempReg.type,
                                               functionPointer: .function(LLVMInstructionConstants.mallocFunction,
                                                                          retType: tempReg.type),
                                               arguments: [.literal(numFieldsInType * LLVMInstructionConstants.numberOfBytesPerStructField)],
                                               result: tempReg)
            
            let destReg = LLVMValue.newRegister(forType: .structure(name: id))
            
            let bitCastInstr = LLVMInstruction.bitcast(source: tempReg,
                                                   destination: destReg)
            
            return ([mallocInstr, bitCastInstr], destReg)
        case let .null(_, typeIndex):
            return ([], .null(type: NullTypeManager.getNullType(forIndex: typeIndex).llvmType))
        case .read:
            let register = LLVMValue.newIntRegister()
            let readInstruction = LLVMInstruction.call(returnType: register.type,
                                                   functionPointer: .function(LLVMInstructionConstants.readHelperFunction,
                                                                              retType: register.type),
                                                   arguments: [],
                                                   result: register)
            
            return ([readInstruction], register)
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
            let result = LLVMValue.newRegister(forType: firstOp.type)
            return ([.multiply(firstOp: firstOp, secondOp: secondOp, destination: result)], result)
        case .divide:
            let result = LLVMValue.newRegister(forType: firstOp.type)
            return ([.signedDivide(firstOp: firstOp, secondOp: secondOp, destination: result)], result)
        case .plus:
            let result = LLVMValue.newRegister(forType: firstOp.type)
            return ([.add(firstOp: firstOp, secondOp: secondOp, destination: result)], result)
        case .minus:
            let result = LLVMValue.newRegister(forType: firstOp.type)
            return ([.subtract(firstOp: firstOp, secondOp: secondOp, destination: result)], result)
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
            let result = LLVMValue.newRegister(forType: firstOp.type)
            return ([.and(firstOp: firstOp, secondOp: secondOp, destination: result)], result)
        case .or:
            let result = LLVMValue.newRegister(forType: firstOp.type)
            return ([.or(firstOp: firstOp, secondOp: secondOp, destination: result)], result)
        }
    }
    
    private func compareInstruction(condCode: LLVMConditionCode, firstOp: LLVMValue, secondOp: LLVMValue) -> ([LLVMInstruction], LLVMValue) {
        let cmpResult = LLVMValue.newRegister(forType: .i1)
        let comp = LLVMInstruction.comparison(condCode: condCode, firstOp: firstOp, secondOp: secondOp, destination: cmpResult)
        let extResult = LLVMValue.newBoolRegister()
        let ext = LLVMInstruction.zeroExtend(source: cmpResult, destination: extResult)
        return ([comp, ext], extResult)
    }
    
    private func fromUnaryExpression(unaryOp: Expression.UnaryOperator, operand: LLVMValue) -> (LLVMInstruction, LLVMValue) {
        switch(unaryOp) {
        case .not:
            let result = LLVMValue.newRegister(forType: operand.type)
            return (.exclusiveOr(firstOp: operand,
                                 secondOp: .literal(LLVMInstructionConstants.trueValue),
                                 destination: result), result)
        case .minus:
            let result = LLVMValue.newRegister(forType: operand.type)
            return (.subtract(firstOp: .literal(0),
                              secondOp: operand,
                              destination: result), result)
        }
    }
}
