//
//  TypeError+lineNumber.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

extension TypeError {
    public var lineNumber: Int {
        switch self {
        case let .deleteTypeError(lineNumber, _),
             let .printTypeError(lineNumber, _),
             let .conditionalGuardTypeError(lineNumber, _),
             let .whileGuardTypeError(lineNumber, _),
             let .returnTypeError(lineNumber, _, _),
             let .returnOutsideOfFunction(lineNumber),
             let .symbolNotFound(_, lineNumber),
             let .structNotFound(_, lineNumber),
             let .functionNotFound(_, lineNumber),
             let .structMemberNotFound(_, _, lineNumber),
             let .dotAccessOnNonStruct(lineNumber, _),
             let .invalidNotOperation(lineNumber, _),
             let .invalidMinusOperation(lineNumber, _),
             let .invalidBinaryExpression(lineNumber, _, _),
             let .invalidComparisonExpression(lineNumber, _, _),
             let .invalidArithmeticExpression(lineNumber, _, _),
             let .invalidEqualityExpression(lineNumber, _, _),
             let .invalidBooleanExpression(lineNumber, _, _),
             let .invalidInvocationTooManyArgs(lineNumber, _),
             let .invalidInvocationTooFewArgs(lineNumber, _),
             let .invalidInvocationMismatchType(lineNumber, _, _, _),
             let .invalidAssignmentMismatchType(lineNumber, _, _),
             let .functionMissingReturn(lineNumber, _, _),
             let .invocationStatementExpError(lineNumber, _),
             let .invalidStructEqualityExpression(lineNumber, _, _):
            return lineNumber
        case .mainFunctionMissing:
            return 0
        }
    }
}
