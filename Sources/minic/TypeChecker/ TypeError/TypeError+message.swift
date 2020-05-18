//
//  TypeError+message.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

extension TypeError {
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
            return "Binary expressions expect equal types. Found '\(leftType)' and '\(rightType)'."
        case let .invalidComparisonExpression(_, leftType, rightType):
            return "Comparison expressions expect 'int' values. Found '\(leftType)' and '\(rightType)'."
        case let .invalidArithmeticExpression(_, leftType, rightType):
            return "Arithmetic expressions expect 'int' values. Found '\(leftType)' and '\(rightType)'."
        case let .invalidEqualityExpression(_, leftType, rightType):
            return "Cannot compare '\(leftType)' and '\(rightType)'."
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
        case let .invalidStructEqualityExpression(_, leftTypeDecl, rightTypeDecl):
            return "Cannot compare equality of differing types '\(leftTypeDecl)' and '\(rightTypeDecl)'."
        case .mainFunctionMissing:
            return "All mini programs must contain a main() function that returns an int."
        }
    }
}
