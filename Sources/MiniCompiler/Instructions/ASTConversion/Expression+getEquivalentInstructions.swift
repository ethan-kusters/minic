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
            
            let (instruction, value) = fromBinaryExpression(binaryOp: op, firstOp: leftValue, secondOp: rightValue)
            
            let instructions = leftInstructions + rightInstructions + [instruction]
            return (instructions, value)
        case let .dot(_, left, id):
            // TODO: Finish me
            return ([], .literal(0))
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
                                                   result: returnRegister)
            
            instructions.append(callInstruction)
            
            return (instructions, returnRegister)
        case .new(lineNumber: let lineNumber, id: let id):
            // TODO: Finish me
            return ([], .literal(0))
        case .null(lineNumber: let lineNumber):
            return ([], .literal(0))
        case .read:
            // TODO: Finish me
            let register = InstructionValue.newIntRegister()
            
            return ([], register)
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
                                      secondOp: InstructionValue) -> (Instruction, InstructionValue) {
        switch(binaryOp) {
        case .times:
            let result = InstructionValue.newIntRegister()
            return (.add(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .divide:
            let result = InstructionValue.newIntRegister()
            return (.signedDivide(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .plus:
            let result = InstructionValue.newIntRegister()
            return (.add(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .minus:
            let result = InstructionValue.newIntRegister()
            return (.subtract(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .lessThan:
            let result = InstructionValue.newBoolRegister()
            return (.comparison(condCode: .slt, type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .lessThanOrEqualTo:
            let result = InstructionValue.newBoolRegister()
            return (.comparison(condCode: .sle, type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .greaterThan:
            let result = InstructionValue.newBoolRegister()
            return (.comparison(condCode: .sgt, type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .greaterThanOrEqualTo:
            let result = InstructionValue.newBoolRegister()
            return (.comparison(condCode: .sge, type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .equalTo:
            let result = InstructionValue.newBoolRegister()
            return (.comparison(condCode: .eq, type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .notEqualTo:
            let result = InstructionValue.newBoolRegister()
            return (.comparison(condCode: .ne, type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .and:
            let result = InstructionValue.newBoolRegister()
            return (.and(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        case .or:
            let result = InstructionValue.newBoolRegister()
            return (.or(type: firstOp.type, firstOp: firstOp, secondOp: secondOp, result: result), result)
        }
    }
    
    private func fromUnaryExpression(unaryOp: Expression.UnaryOperator, operand: InstructionValue) -> (Instruction, InstructionValue) {
        switch(unaryOp) {
        case .not:
            let result = InstructionValue.newBoolRegister()
            return (.exclusiveOr(type: operand.type,
                                 firstOp: operand,
                                 secondOp: .literal(InstructionConstants.trueValue),
                                 result: result), result)
        case .minus:
            let result = InstructionValue.newIntRegister()
            return (.subtract(type: operand.type,
                              firstOp: operand,
                              secondOp: .literal(0),
                              result: result), result)
        }
    }
    
    
}
