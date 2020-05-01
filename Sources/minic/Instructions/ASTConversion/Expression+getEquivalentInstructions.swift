//
//  Expression+getEquivalentInstructions.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

extension Expression {
    func getEquivalentInstructions(_ context: TypeContext) -> (instructions: [Instruction], value: InstructionValue) {
        switch(self) {
        case let .binary(_, op, left, right):
            let (leftInstructions, leftValue) = left.getEquivalentInstructions(context)
            let (rightInstructions, rightValue) = right.getEquivalentInstructions(context)
            
            let (expInstructions, value) = fromBinaryExpression(binaryOp: op, firstOp: leftValue, secondOp: rightValue)
            
            let instructions = leftInstructions + rightInstructions + expInstructions
            return (instructions, value)
        case let .dot(_, left, id):
            let (leftInstructions, leftValue) = left.getEquivalentInstructions(context)
            
            let structTypeDeclaration: TypeDeclaration
            
            if case let .identifier(_, id) = left {
                let structPointer = context.getInstructionPointer(from: id)
                
                guard case let .structure(name: name) = structPointer.type else {
                    fatalError("Type checker should have caught this. Dot access on not-struct value.")
                }
                
                structTypeDeclaration = context.getStruct(name)!
            } else if case let .dot(_, left, id) = left {
                var idChain = [id]
                var currentLeft: Expression = left
                while case let .dot(_, left, id) = currentLeft {
                    currentLeft = left
                    idChain.append(id)
                }
                
                guard case let .identifier(_, baseID) = currentLeft else { fatalError() }
                
                let structPointer = context.getInstructionPointer(from: baseID)
                
                guard case let .structure(name: baseStructTypeName) = structPointer.type else {
                    fatalError("Type checker should have caught this. Dot access on not-struct value.")
                }
                
                var currentStruct = context.getStruct(baseStructTypeName)!
                
                idChain.reversed().forEach { id in
                    let currentStructPointer = currentStruct.fields[id]!.type.equivalentInstructionType
                    
                    guard case let .structure(name: currentStructName) = currentStructPointer else {
                        fatalError("Type checker should have caught this. Dot access on not-struct value.")
                    }
                    
                    currentStruct = context.getStruct(currentStructName)!
                }
                
                structTypeDeclaration = currentStruct
            } else if case let .invocation(_, functionName, _) = left {
                let functionRetType = context.getFunction(functionName)!.retType.equivalentInstructionType
                
                guard case let .structure(name: name) = functionRetType else {
                    fatalError("Type checker should have caught this. Dot access on not-struct value.")
                }
                
                structTypeDeclaration = context.getStruct(name)!
                
            } else {
                fatalError("Type checker should have caught this. Dot access on non-identifier value.")
            }
            
            let fieldIndex = structTypeDeclaration.fields.firstIndex(where: {
                $0.name == id
            })!
            
            let fieldType = structTypeDeclaration.fields[fieldIndex].type.equivalentInstructionType
            
            let ptrResult = InstructionValue.newRegister(forType: fieldType)
            let getPtrInstruction = Instruction.getElementPointer(structureType: .structureType(structTypeDeclaration.name),
                                                                  structurePointer: leftValue,
                                                                  elementIndex: fieldIndex,
                                                                  result: ptrResult)
            
            let ldResult = InstructionValue.newRegister(forType: fieldType)
            let loadInstr = Instruction.load(valueType: fieldType,
                                             pointerType: fieldType,
                                             pointer: .localValue(ptrResult.identifier, type: ptrResult.type),
                                             result: ldResult)
            
            return (leftInstructions + [getPtrInstruction, loadInstr], ldResult)
        case .false:
            return ([], .literal(InstructionConstants.falseValue))
        case let .identifier(_, id):
            let pointerVal = context.getInstructionPointer(from: id)
            let destinationRegister = InstructionValue.newRegister(forType: pointerVal.type)
            
            let loadInstruction = Instruction.load(valueType: pointerVal.type,
                                                   pointerType: pointerVal.type,
                                                   pointer: pointerVal,
                                                   result: destinationRegister)
            
            return ([loadInstruction], destinationRegister)
        case let .integer(_, value):
            return ([], .literal(value))
        case let .invocation(_, name, arguments):
            var instructions = [Instruction]()
            
            let argumentValues = arguments.map { expression -> InstructionValue in
                let (newInstructions, newValue) = expression.getEquivalentInstructions(context)
                instructions.append(contentsOf: newInstructions)
                return newValue
            }
            
            let returnType = context.getFunction(name)!.retType.equivalentInstructionType
            
            let returnRegister = InstructionValue.newRegister(forType: returnType)
            
            let callInstruction = Instruction.call(returnType: returnType,
                                                   functionPointer: .function(name, retType: returnType),
                                                   arguments: argumentValues,
                                                   result: returnType == .void ? nil : returnRegister)
            
            instructions.append(callInstruction)
            
            return (instructions, returnRegister)
        case let .new(_, id):
            let numFieldsInType = context.getStruct(id)!.fields.count
            
            let tempReg = InstructionValue.newRegister(forType: .pointer(.i8))
            let mallocInstr = Instruction.call(returnType: tempReg.type,
                                               functionPointer: .function(InstructionConstants.mallocFunction,
                                                                          retType: tempReg.type),
                                               arguments: [.literal(numFieldsInType * InstructionConstants.numberOfBytesPerStructField)],
                                               result: tempReg)
            
            let destReg = InstructionValue.newRegister(forType: .structure(name: id))
            
            let bitCastInstr = Instruction.bitcast(currentType: tempReg.type,
                                                   value: tempReg,
                                                   destinationType: destReg.type,
                                                   result: destReg)
            
            return ([mallocInstr, bitCastInstr], destReg)
        case let .null(_, typeIndex):
            return ([], .null(type: NullTypeManager.getNullType(forIndex: typeIndex).equivalentInstructionType))
        case .read:
            let register = InstructionValue.newIntRegister()
            let readInstruction = Instruction.call(returnType: register.type,
                                                   functionPointer: .function(InstructionConstants.readHelperFunction,
                                                                              retType: register.type),
                                                   arguments: [],
                                                   result: register)
            
            return ([readInstruction], register)
        case .true:
            return ([], .literal(InstructionConstants.trueValue))
        case let .unary(_, op, operand):
            let (operandInstructions, operandValue) = operand.getEquivalentInstructions(context)
            let (instruction, value) = fromUnaryExpression(unaryOp: op, operand: operandValue)
            
            return (operandInstructions + [instruction], value)
        }
    }
    
    private func fromBinaryExpression(binaryOp: Expression.BinaryOperator,
                                      firstOp: InstructionValue,
                                      secondOp: InstructionValue) -> ([Instruction], InstructionValue) {
        switch(binaryOp) {
        case .times:
            let result = InstructionValue.newRegister(forType: firstOp.type)
            return ([.multiply(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result)], result)
        case .divide:
            let result = InstructionValue.newRegister(forType: firstOp.type)
            return ([.signedDivide(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result)], result)
        case .plus:
            let result = InstructionValue.newRegister(forType: firstOp.type)
            return ([.add(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result)], result)
        case .minus:
            let result = InstructionValue.newRegister(forType: firstOp.type)
            return ([.subtract(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result)], result)
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
            let result = InstructionValue.newRegister(forType: firstOp.type)
            return ([.and(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result)], result)
        case .or:
            let result = InstructionValue.newRegister(forType: firstOp.type)
            return ([.or(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result)], result)
        }
    }
    
    private func compareInstruction(condCode: InstructionConditionCode, firstOp: InstructionValue, secondOp: InstructionValue) -> ([Instruction], InstructionValue) {
        let cmpResult = InstructionValue.newRegister(forType: .i1)
        let comp = Instruction.comparison(condCode: condCode, type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: cmpResult)
        let extResult = InstructionValue.newBoolRegister()
        let ext = Instruction.zeroExtend(currentType: cmpResult.type, value: cmpResult, destinationType: extResult.type, result: extResult)
        return ([comp, ext], extResult)
    }
    
    private func fromUnaryExpression(unaryOp: Expression.UnaryOperator, operand: InstructionValue) -> (Instruction, InstructionValue) {
        switch(unaryOp) {
        case .not:
            let result = InstructionValue.newRegister(forType: operand.type)
            return (.exclusiveOr(type: operand.type,
                                 firstOp: operand,
                                 secondOp: .literal(InstructionConstants.trueValue),
                                 result: result), result)
        case .minus:
            let result = InstructionValue.newRegister(forType: operand.type)
            return (.subtract(type: operand.type,
                              firstOp: .literal(0),
                              secondOp: operand,
                              result: result), result)
        }
    }
}
