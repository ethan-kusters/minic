//
//  TypeError.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/12/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

enum TypeError: Error {
    
    // MARK: - Program Errors
    case mainFunctionMissing
    
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
    case invalidStructEqualityExpression(lineNumber: Int,
        leftTypeDecl: TypeDeclaration, rightTypeDecl: TypeDeclaration)
    case invalidBooleanExpression(lineNumber: Int, leftType: Type, rightType: Type)
    case invalidInvocationTooManyArgs(lineNumber: Int, functionName: String)
    case invalidInvocationTooFewArgs(lineNumber: Int, functionName: String)
    case invalidInvocationMismatchType(lineNumber: Int, functionName: String, argType: Type, paramType: Type)
}

