//
//  Expression.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

enum Expression {
    
    indirect case binary(lineNumber: Int, op: BinaryOperator, left: Expression, right: Expression)
    
    indirect case dot(lineNumber: Int, left: Expression, id: String)
    
    case `false`(lineNumber: Int)
    
    case identifier(lineNumber: Int, id: String)
    
    case integer(lineNumber: Int, value: Int)
    
    indirect case invocation(lineNumber: Int, name: String, arguments: [Expression])
    
    case new(lineNumber: Int, id: String)
    
    case null(lineNumber: Int)
    
    case read(lineNumber: Int)
    
    case `true`(lineNumber: Int)
    
    indirect case unary(lineNumber: Int, op: UnaryOperator, operand: Expression)
    
}

extension Expression {
    enum BinaryOperator: String {
        case times = "*"
        case divide = "/"
        case plus = "+"
        case minus = "-"
        case lessThan = "<"
        case lessThanOrEqualTo = "<="
        case greaterThan = ">"
        case greaterThanOrEqualTo = ">="
        case equalTo = "=="
        case notEqualTo = "!="
        case and = "&&"
        case or = "||"
    }
    
    enum UnaryOperator: String {
        case not = "!"
        case minus = "-"
    }
}

extension Expression: CustomStringConvertible {
    var description: String {
        switch(self) {
        case .binary:
            return "binary"
        case .dot:
            return "dot"
        case .false:
            return "false"
        case .identifier:
            return "identifier"
        case .integer:
            return "int"
        case .invocation:
            return "invocation"
        case .new:
            return "new"
        case .null:
            return "null"
        case .read:
            return "read"
        case .true:
            return "true"
        case .unary:
            return "unary"
        }
    }
}
