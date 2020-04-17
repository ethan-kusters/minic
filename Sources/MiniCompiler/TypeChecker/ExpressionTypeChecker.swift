//
//  ExpressionTypeChecker.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/10/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class ExpressionTypeChecker {
    let context: TypeContext
    let errorHandler: ErrorHandler
    
    init(context: TypeContext, errorHandler: ErrorHandler) {
        self.context = context
        self.errorHandler = errorHandler
    }
    
    @discardableResult
    func callAsFunction(_ expression: Expression) -> Type? {
        typeCheck(expression)
    }
    
    @discardableResult
    private func typeCheck(_ expression: Expression) -> Type? {
        switch expression {
        case .binary:
            return typeCheckBinaryExp(expression)
        case let .dot(lineNumber, left, id):
            guard let leftType = typeCheck(left) else { return nil }
            guard case let .struct(_, name) = leftType else {
                errorHandler.report(.dotAccessOnNonStruct(lineNumber, typeUsed: leftType))
                return nil
            }
            
            guard let structType = context.getStruct(name) else {
                errorHandler.report(.structNotFound(name, lineNumber: lineNumber))
                return nil
            }
            
            guard let memberType = structType.fields[id] else {
                errorHandler.report(.structMemberNotFound(id, structName: name, lineNumber: lineNumber))
                return nil
            }
            
            return memberType.type
        case .false:
            return .bool
        case let .identifier(lineNumber, id):
            guard let symbol = context.getSymbolType(id) else {
                errorHandler.report(.symbolNotFound(id, lineNumber: lineNumber))
                return nil
            }
            
            return symbol
        case .integer:
            return .int
        case .invocation:
            return typeCheckInvocationExp(expression)
        case let .new(lineNumber, id):
            guard let newStruct = context.getStruct(id) else {
                errorHandler.report(.structNotFound(id, lineNumber: lineNumber))
                return nil
            }
            
            return .struct(lineNumber: newStruct.lineNumber, name: newStruct.name)
        case let .null(lineNumber):
            return .struct(lineNumber: lineNumber, name: "null")
        case .read:
            return .int
        case .true:
            return .bool
        case let .unary(lineNumber, op, operand):
            guard let operandType = typeCheck(operand) else { return nil }
            
            switch op {
            case .not:
                guard operandType == .bool else {
                    errorHandler.report(.invalidNotOperation(lineNumber, typeUsed: operandType))
                    return nil
                }
                
                return .bool
            case .minus:
                guard operandType == .int else {
                    errorHandler.report(.invalidMinusOperation(lineNumber, typeUsed: operandType))
                    return nil
                }
                
                return .int
            }
        }
    }
    
    private func typeCheckBinaryExp(_ exp: Expression) -> Type? {
        guard case let .binary(lineNumber, op, left, right) = exp else {
            fatalError("\(#function) must be called with `Expression.binary`. 😡")
        }
        
        guard let leftType = typeCheck(left) else { return nil }
        guard let rightType = typeCheck(right) else { return nil }
        
        guard leftType == rightType else {
            errorHandler.report(.invalidBinaryExpression(lineNumber: lineNumber,
                                                         leftType: leftType,
                                                         rightType: rightType))
            
            return nil
        }

        switch op {
        case .times, .divide, .minus, .plus:
            guard leftType == .int else {
                errorHandler.report(.invalidArithmeticExpression(lineNumber: lineNumber,
                                                                 leftType: leftType,
                                                                 rightType: rightType))
                
                return nil
            }
            
            return .int
        case .lessThan, .lessThanOrEqualTo, .greaterThan, .greaterThanOrEqualTo:
            guard leftType == .int else {
                errorHandler.report(.invalidComparisonExpression(lineNumber: lineNumber,
                                                                 leftType: leftType,
                                                                 rightType: rightType))
                
                return nil
            }
            
            return .bool
        case .equalTo, .notEqualTo:
            guard leftType == .bool || leftType == .int else {
                errorHandler.report(.invalidEqualityExpression(lineNumber: lineNumber,
                                                               leftType: leftType,
                                                               rightType: rightType))
                
                return nil
            }
            
            return .bool
        case .and, .or:
            guard leftType == .bool else {
                errorHandler.report(.invalidBooleanExpression(lineNumber: lineNumber,
                                                              leftType: leftType,
                                                              rightType: rightType))
                
                return nil
            }
            
            return .bool
        }
    }
    
    private func typeCheckInvocationExp(_ exp: Expression) -> Type? {
        guard case let .invocation(lineNumber, name, arguments) = exp else {
            fatalError("\(#function) must be called with `Expression.invocation`. 😡")
        }
        
        guard let function = context.getFunction(name) else {
            errorHandler.report(.functionNotFound(name, lineNumber: lineNumber))
            return nil
        }
        
        let argumentTypes = arguments.compactMap(typeCheck)
        guard argumentTypes.count == arguments.count else { return nil }
        
        guard argumentTypes.count == function.parameters.count else {
            if argumentTypes.count > function.parameters.count {
                errorHandler.report(.invalidInvocationTooManyArgs(lineNumber: lineNumber,
                                                                  functionName: name))
                
                return nil
            } else {
                errorHandler.report(.invalidInvocationTooFewArgs(lineNumber: lineNumber,
                                                                 functionName: name))
                
                return nil
            }
        }
        
        for (index, argType) in argumentTypes.enumerated() {
            guard argType == function.parameters[index].type else {
                errorHandler.report(.invalidInvocationMismatchType(lineNumber: lineNumber,
                                                                   functionName: name,
                                                                   argType: argType,
                                                                   paramType: function.parameters[index].type))
                
                return nil
            }
        }
        
        return function.retType
    }
    
}
