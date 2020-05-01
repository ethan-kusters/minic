//
//  StatementTypeChecker.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/10/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class StatementTypeChecker {
    private let context: TypeContext
    private let errorHandler: ErrorHandler
    private let expressionTypeChecker: ExpressionTypeChecker
    
    init(context: TypeContext, errorHandler: ErrorHandler) {
        self.context = context
        self.errorHandler = errorHandler
        expressionTypeChecker = ExpressionTypeChecker(context: context, errorHandler: errorHandler)
    }
    
    func callAsFunction(_ statement: Statement) -> ReturnEquivalent {
        return typeCheck(statement)
    }
    
    private func typeCheck(_ statement: Statement) -> ReturnEquivalent {
        switch(statement) {
        case .assignment:
            typeCheckAssignment(statement)
            return .notReturnEquivalent
        case let .block(_, statements):
            let statementReturnEquivalences = statements.map(typeCheck)
            guard statementReturnEquivalences.contains(.isReturnEquivalent) else {
                return .notReturnEquivalent
            }
            
            return .isReturnEquivalent
        case let .conditional(lineNumber, guardExp, thenStmt, elseStmt):
            guard let guardType = expressionTypeChecker(guardExp) else { return .notReturnEquivalent }
            
            guard case .bool = guardType else {
                errorHandler.report(.conditionalGuardTypeError(lineNumber: lineNumber,
                                                               typeUsed: guardType))
                
                return .notReturnEquivalent
            }
            
            return typeCheck(thenStmt) && typeCheck(elseStmt ?? Statement.emptyBlock())
        case let .delete(lineNumber, expression):
            guard let expressionType = expressionTypeChecker(expression) else { return .notReturnEquivalent }
            guard case .struct = expressionType else {
                errorHandler.report(.deleteTypeError(lineNumber: lineNumber, typeUsed: expressionType))
                
                return .notReturnEquivalent
            }
            
            return .notReturnEquivalent
        case let .invocation(lineNumber, expression):
            guard case .invocation = expression else {
                errorHandler.report(.invocationStatementExpError(lineNumber: lineNumber,
                                                                 expressionUsed: expression))
                
                return .notReturnEquivalent
            }
            
            expressionTypeChecker(expression)
            return .notReturnEquivalent
        case let .printLn(lineNumber, expression), let .print(lineNumber, expression):
            guard let expressionType = expressionTypeChecker(expression) else { return .notReturnEquivalent }
            guard case .int = expressionType else {
                errorHandler.report(.printTypeError(lineNumber: lineNumber,
                                                    typeUsed: expressionType))
                
                return .notReturnEquivalent
            }
        case .return:
            return typeCheckReturn(statement)
        case let .while(lineNumber, guardExp, body):
            guard let guardType = expressionTypeChecker(guardExp) else { return .notReturnEquivalent }
            guard case .bool = guardType else {
                errorHandler.report(.whileGuardTypeError(lineNumber: lineNumber,
                                                         typeUsed: guardType))
                
                return .notReturnEquivalent
            }
            
            _ = typeCheck(body)
            return .notReturnEquivalent
        }
        
        return .notReturnEquivalent
    }
    
    private func typeCheckAssignment(_ statement: Statement) {
        guard case let .assignment(lineNumber, lValue, source) = statement else {
            fatalError("\(#function) must be called with `Statement.assignment`. 😡")
        }
        
        guard let sourceType = expressionTypeChecker(source) else { return }
        if let leftExpression = lValue.leftExpression {
            guard let leftExpType = expressionTypeChecker(leftExpression) else { return }
            guard case let .struct(_, structName) = leftExpType else {
                errorHandler.report(.dotAccessOnNonStruct(lineNumber, typeUsed: leftExpType))
                return
            }
            
            guard let structDeclaration = context.getStruct(structName) else {
                errorHandler.report(.structNotFound(structName, lineNumber: lineNumber))
                return
            }
            
            guard let structFieldType = structDeclaration.fields[lValue.id] else {
                errorHandler.report(.structMemberNotFound(lValue.id,
                                                          structName: structName,
                                                          lineNumber: lineNumber))
                
                return
            }
            
            guard sourceType == structFieldType.type else {
                errorHandler.report(.invalidAssignmentMismatchType(lineNumber,
                                                                   typeUsed: sourceType,
                                                                   typeExpected: structFieldType.type))
                
                return
            }
        } else {
            guard let idType = context.getSymbolType(lValue.id) else {
                errorHandler.report(.symbolNotFound(lValue.id, lineNumber: lineNumber))
                return
            }
            
            guard sourceType == idType else {
                errorHandler.report(.invalidAssignmentMismatchType(lineNumber,
                                                                   typeUsed: sourceType,
                                                                   typeExpected: idType))
                
                return
            }
        }
    }
    
    private func typeCheckReturn(_ statement: Statement) -> ReturnEquivalent {
        guard case let .return(lineNumber, expression) = statement else {
            fatalError("\(#function) must be called with `Statement.return`. 😡")
        }
        
        guard let expectedReturnType = context.getReturnType() else {
            errorHandler.report(.returnOutsideOfFunction(lineNumber: lineNumber))
            
            return .notReturnEquivalent
        }
        
        
        if let expression = expression {
            guard let expressionType = expressionTypeChecker(expression) else { return .notReturnEquivalent }
            
            guard expressionType == expectedReturnType else {
                errorHandler.report(.returnTypeError(lineNumber: lineNumber,
                                                     typeUsed: expressionType,
                                                     typeExpected: expectedReturnType))
                
                return .notReturnEquivalent
            }
        } else if expectedReturnType != .void {
            errorHandler.report(.returnTypeError(lineNumber: lineNumber,
                                                 typeUsed: .void,
                                                 typeExpected: expectedReturnType))
            
            return .notReturnEquivalent
        }
        
        return .isReturnEquivalent
    }
}
