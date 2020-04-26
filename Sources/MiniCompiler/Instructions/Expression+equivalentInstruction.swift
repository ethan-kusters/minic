//
//  Expression+equivalentInstruction.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

extension Expression {
    var equivalentInstructions: ([Instruction], InstructionValue) {
        switch(self) {
        case let .binary(_, op, left, right):
            let (leftInstructions, leftValue) = left.equivalentInstructions
            let (rightInstructions, rightValue) = right.equivalentInstructions
            
            let (instruction, value) = fromBinaryExpression(binaryOp: op, firstOp: leftValue, secondOp: rightValue)
            
            let instructions = leftInstructions + rightInstructions + [instruction]
            return (instructions, value)
        case .dot(lineNumber: let lineNumber, left: let left, id: let id):
            <#code#>
        case .false:
            return ([], .literal(InstructionConstants.falseValue))
        case let .identifier(_, id):
            return ([], .)
        case let .integer(_, value):
            return ([], .literal(value))
        case .invocation(lineNumber: let lineNumber, name: let name, arguments: let arguments):
            <#code#>
        case .new(lineNumber: let lineNumber, id: let id):
            <#code#>
        case .null(lineNumber: let lineNumber):
            <#code#>
        case .read:
            <#code#>
        case .true:
            return ([], .literal(InstructionConstants.trueValue))
        case let .unary(_, op, operand):
            let (operandInstructions, operandValue) = operand.equivalentInstructions
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
