//
//  MiniToAstExpressionVisitor.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class MiniToAstExpressionVisitor: MiniBaseVisitor<Expression> {
    override func visitIntegerExpr(_ ctx: MiniParser.IntegerExprContext) -> Expression? {
        guard let value = ctx.INTEGER()?.getText() else { return nil }
        guard let intValue = Int.init(argument: value) else { return nil }
        return .integer(lineNumber: ctx.startLineNumber, value: intValue)
    }
    
    override func visitTrueExpr(_ ctx: MiniParser.TrueExprContext) -> Expression? {
        return .true(lineNumber: ctx.startLineNumber)
    }
    
    override func visitIdentifierExpr(_ ctx: MiniParser.IdentifierExprContext) -> Expression? {
        guard let id = ctx.ID()?.getText() else { return nil }
        
        return .identifier(lineNumber: ctx.startLineNumber, id: id)
    }
    
    override func visitBinaryExpr(_ ctx: MiniParser.BinaryExprContext) -> Expression? {
        guard let opText = ctx.op.getText(),
            let leftExpr = visit(ctx.lft),
            let rightExpr = visit(ctx.rht) else { return nil }
        
        return .binary(lineNumber: ctx.op.getLine(),
                       op: Expression.BinaryOperator(rawValue: opText)!,
                       left: leftExpr,
                       right: rightExpr)
    }
    
    override func visitNewExpr(_ ctx: MiniParser.NewExprContext) -> Expression? {
        guard let id = ctx.ID()?.getText() else { return nil }
        
        return .new(lineNumber: ctx.startLineNumber, id: id)
    }
    
    override func visitDotExpr(_ ctx: MiniParser.DotExprContext) -> Expression? {
        guard let id = ctx.ID()?.getText(),
            let expressionTree = ctx.expression(),
            let expression = visit(expressionTree) else { return nil }
        
        return .dot(lineNumber: ctx.startLineNumber, left: expression, id: id)
    }
    
    override func visitUnaryExpr(_ ctx: MiniParser.UnaryExprContext) -> Expression? {
        guard let opText = ctx.op.getText(),
            let expressionTree = ctx.expression(),
            let expression = visit(expressionTree) else { return nil }
        
        return .unary(lineNumber: ctx.op.getLine(),
                      op: Expression.UnaryOperator(rawValue: opText)!,
                      operand: expression)
    }
    
    override func visitInvocationExpr(_ ctx: MiniParser.InvocationExprContext) -> Expression? {
        guard let id = ctx.ID()?.getText(),
            let argumentsCtx = ctx.arguments() else { return nil }
        
        let arguments = argumentsCtx.expression().compactMap {
            visit($0)
        }
        
        return .invocation(lineNumber: ctx.startLineNumber,
                           name: id,
                           arguments: arguments)
    }
    
    override func visitFalseExpr(_ ctx: MiniParser.FalseExprContext) -> Expression? {
        return .false(lineNumber: ctx.startLineNumber)
    }
    
    override func visitNullExpr(_ ctx: MiniParser.NullExprContext) -> Expression? {
        return .null(lineNumber: ctx.startLineNumber)
    }
    
    override func visitNestedExpr(_ ctx: MiniParser.NestedExprContext) -> Expression? {
        guard let expressionCtx = ctx.expression() else { return nil }
        return visit(expressionCtx)
    }
    
    override func defaultResult() -> Expression? {
        return .null(lineNumber: -1)
    }
    
}
