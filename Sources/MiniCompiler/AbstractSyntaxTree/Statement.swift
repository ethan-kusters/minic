//
//  Statement.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

enum Statement {
    
    case assignment(lineNumber: Int, lValue: LValue, source: Expression)
    
    indirect case block(lineNumber: Int, statements: [Statement])
    
    indirect case conditional(lineNumber: Int, guard: Expression,
        then: Statement, else: Statement)
    
    case delete(lineNumber: Int, expression: Expression)
    
    case invocation(lineNumber: Int, expression: Expression)
    
    case printLn(lineNumber: Int, expression: Expression)
    
    case print(lineNumber: Int, expression: Expression)
    
    case `return`(lineNumber: Int, expression: Expression?)
    
    indirect case `while`(lineNumber: Int, guard: Expression, body: Statement)
    
}

extension Statement {
    static func emptyBlock() -> Statement {
        .block(lineNumber: -1, statements: [])
    }
}
