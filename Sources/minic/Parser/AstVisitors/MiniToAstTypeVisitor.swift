//
//  MiniToAstTypeVisitor.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class MiniToAstTypeVisitor: MiniBaseVisitor<Type> {
    override func visitIntType(_ ctx: MiniParser.IntTypeContext) -> Type? {
        return .int
    }
    
    override func visitBoolType(_ ctx: MiniParser.BoolTypeContext) -> Type? {
        return .bool
    }
    
    override func visitStructType(_ ctx: MiniParser.StructTypeContext) -> Type? {
        guard let id = ctx.ID()?.getText() else { return nil }
        
        return .struct(lineNumber: ctx.startLineNumber, name: id)
    }
    
    override func visitReturnTypeReal(_ ctx: MiniParser.ReturnTypeRealContext) -> Type? {
        guard let ctxType = ctx.type() else { return nil }
        return visit(ctxType)
    }
    
    override func visitReturnTypeVoid(_ ctx: MiniParser.ReturnTypeVoidContext) -> Type? {
        return .void
    }
    
    override func defaultResult() -> Type? {
        return .void
    }
}
