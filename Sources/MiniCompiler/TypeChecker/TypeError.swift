//
//  TypeError.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/12/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation
import ColorizeSwift

enum TypeError: Error {
    
    // MARK: - Function Body Type Checker
    case functionMissingReturn(lineNumber: Int, functionName: String, returnType: Type)
    
    // MARK: - Statement Type Checker
    
    case deleteTypeError(lineNumber: Int, typeUsed: Type)
    case printTypeError(lineNumber: Int, typeUsed: Type)
    case conditionalGuardTypeError(lineNumber: Int, typeUsed: Type)
    case whileGuardTypeError(lineNumber: Int, typeUsed: Type)
    case returnTypeError(lineNumber: Int, typeUsed: Type, typeExpected: Type)
    case returnOutsideOfFunction(lineNumber: Int)
    case invocationStatementExpError(lineNumber: Int, expressionUsed: Expression)
    
    // MARK: - Expression Type Checker
    
    case symbolNotFound(_ id: String, lineNumber: Int)
    case structNotFound(_ name: String, lineNumber: Int)
    case functionNotFound(_ name: String, lineNumber: Int)
    case structMemberNotFound(_ id: String, structName: String, lineNumber: Int)
    case dotAccessOnNonStruct(_ lineNumber: Int, typeUsed: Type)
    case invalidAssignmentMismatchType(_ lineNumber: Int, typeUsed: Type, typeExpected: Type)
    case invalidNotOperation(_ lineNumber: Int, typeUsed: Type)
    case invalidMinusOperation(_ lineNumber: Int, typeUsed: Type)
    case invalidBinaryExpression(lineNumber: Int, leftType: Type, rightType: Type)
    case invalidComparisonExpression(lineNumber: Int, leftType: Type, rightType: Type)
    case invalidArithmeticExpression(lineNumber: Int, leftType: Type, rightType: Type)
    case invalidEqualityExpression(lineNumber: Int, leftType: Type, rightType: Type)
    case invalidBooleanExpression(lineNumber: Int, leftType: Type, rightType: Type)
    case invalidInvocationTooManyArgs(lineNumber: Int, functionName: String)
    case invalidInvocationTooFewArgs(lineNumber: Int, functionName: String)
    case invalidInvocationMismatchType(lineNumber: Int, functionName: String, argType: Type, paramType: Type)
}

extension TypeError {
    var lineNumber: Int {
        switch self {
        case let .deleteTypeError(lineNumber, _):
            return lineNumber
        case let .printTypeError(lineNumber, _):
            return lineNumber
        case let .conditionalGuardTypeError(lineNumber, _):
            return lineNumber
        case let .whileGuardTypeError(lineNumber, _):
            return lineNumber
        case let .returnTypeError(lineNumber, _, _):
            return lineNumber
        case let .returnOutsideOfFunction(lineNumber):
            return lineNumber
        case let .symbolNotFound(_, lineNumber):
            return lineNumber
        case let .structNotFound(_, lineNumber):
            return lineNumber
        case let .functionNotFound(_, lineNumber):
            return lineNumber
        case let .structMemberNotFound(_, _, lineNumber):
            return lineNumber
        case let .dotAccessOnNonStruct(lineNumber, _):
            return lineNumber
        case let .invalidNotOperation(lineNumber, _):
            return lineNumber
        case let .invalidMinusOperation(lineNumber, _):
            return lineNumber
        case let .invalidBinaryExpression(lineNumber, _, _):
            return lineNumber
        case let .invalidComparisonExpression(lineNumber, _, _):
            return lineNumber
        case let .invalidArithmeticExpression(lineNumber, _, _):
            return lineNumber
        case let .invalidEqualityExpression(lineNumber, _, _):
            return lineNumber
        case let .invalidBooleanExpression(lineNumber, _, _):
            return lineNumber
        case let .invalidInvocationTooManyArgs(lineNumber, _):
            return lineNumber
        case let .invalidInvocationTooFewArgs(lineNumber, _):
            return lineNumber
        case let .invalidInvocationMismatchType(lineNumber, _, _, _):
            return lineNumber
        case let .invalidAssignmentMismatchType(lineNumber, _, _):
            return lineNumber
        case let .functionMissingReturn(lineNumber, _, _):
            return lineNumber
        case let .invocationStatementExpError(lineNumber, _):
            return lineNumber
        }
    }
    
    var message: String {
        switch self {
        case let .deleteTypeError(_, typeUsed):
            return "'delete' expects a structure reference. Found '\(typeUsed)'."
        case let .printTypeError(_, typeUsed):
            return "'print' expects an 'int'. Found '\(typeUsed)'."
        case let .conditionalGuardTypeError(_, typeUsed):
            return "if statement guard expects type 'bool'. Found '\(typeUsed)'."
        case let .whileGuardTypeError(_, typeUsed):
            return "while statement guard expects type 'bool'. Found '\(typeUsed)'."
        case let .returnTypeError(_, typeUsed, typeExpected):
            return "Function expects return type '\(typeExpected)'. Found '\(typeUsed)'."
        case .returnOutsideOfFunction(_):
            return "Return statements are only valid inside of functions."
        case let .symbolNotFound(id, _):
            return  "Use of unresolved identifier '\(id)'."
        case let .structNotFound(name, _):
            return  "Use of unresolved identifier '\(name)'."
        case let .functionNotFound(name, _):
            return "Use of unresolved identifier '\(name)'."
        case let .structMemberNotFound(id, structName, _):
            return "Member '\(id)' not found in 'struct \(structName)'."
        case let .dotAccessOnNonStruct(_, typeUsed):
            return "Dot operations expect 'struct' type. Found '\(typeUsed)'. "
        case let .invalidNotOperation(_, typeUsed):
            return "Not operations expect 'bool' type. Found '\(typeUsed)'."
        case let .invalidMinusOperation(_, typeUsed):
            return "Minus operations expect 'int' type. Found '\(typeUsed)'."
        case let .invalidBinaryExpression(_, leftType, rightType):
            return "Binary expressions expect matching types. Found '\(leftType)' and '\(rightType)'."
        case let .invalidComparisonExpression(_, leftType, rightType):
            return "Comparison expressions expect 'int' values. Found '\(leftType)' and '\(rightType)'."
        case let .invalidArithmeticExpression(_, leftType, rightType):
            return "Arithmetic expressions expect 'int' values. Found '\(leftType)' and '\(rightType)'."
        case let .invalidEqualityExpression(_, leftType, rightType):
            return "Equality expressions expect 'int' values or structure references. Found '\(leftType)' and '\(rightType)'."
        case let .invalidBooleanExpression(_, leftType, rightType):
            return "Boolean expressions expect 'bool' values. Found '\(leftType)' and '\(rightType)'."
        case let .invalidInvocationTooManyArgs(_, functionName):
            return "Extra argument in call to function '\(functionName)'."
        case let .invalidInvocationTooFewArgs(_, functionName):
            return "Missing arguments in call to function '\(functionName)'."
        case let .invalidInvocationMismatchType(_, functionName, argType, paramType):
            return "Expected type '\(paramType)' in call to '\(functionName)'. Found '\(argType)'."
        case let .invalidAssignmentMismatchType(_, typeUsed, typeExpected):
            return "Cannot assign value of type '\(typeUsed)' to type '\(typeExpected)'."
        case let .functionMissingReturn(_, functionName, returnType):
            return "Function '\(functionName)' missing return. Expected to return type '\(returnType)'."
        case let .invocationStatementExpError(_, expressionUsed):
            return "Invocation statement expects 'invocation' expression. Found '\(expressionUsed)'."
        }
    }
}

extension TypeError: LocalizedError {
    var errorDescription: String? {
        return "Line \(lineNumber): \(message)"
    }
    
    private func formatError(lineNumber: Int, error: String) {
        print("\(lineNumber)".blue() + "|" + error.white())
    }
}
