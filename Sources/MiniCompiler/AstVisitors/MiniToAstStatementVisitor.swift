//
//  MiniToAstStatementVisitor.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class MiniToAstStatementVisitor: MiniBaseVisitor<Statement> {
    private let expressionVisitor = MiniToAstExpressionVisitor()
    
    override func visitNestedBlock(_ ctx: MiniParser.NestedBlockContext) -> Statement? {
        guard let blockCtx = ctx.block() else { return nil }
        return visit(blockCtx)
    }
    
    override func visitAssignment(_ ctx: MiniParser.AssignmentContext) -> Statement? {
        guard let lValueCtx = ctx.lvalue(),
            let lValue = visitLValue(lValueCtx) else { return nil }
        
        let sourceExpression: Expression
        
        if let expressionCtx = ctx.expression() {
            guard let visitedExpression =
                expressionVisitor.visit(expressionCtx) else { return nil }
            
            sourceExpression = visitedExpression
        } else {
            sourceExpression = .read(lineNumber: ctx.startLineNumber)
        }
        
        return .assignment(lineNumber: ctx.startLineNumber,
                           lValue: lValue,
                           source: sourceExpression)
    }
    
    private func visitLValue(_ ctx: MiniParser.LvalueContext) -> LValue? {
        if let lValueIdCtx = ctx as? MiniParser.LvalueIdContext {
            guard let id = lValueIdCtx.ID()?.getText() else { return nil }
            
            return LValue(lineNumber: lValueIdCtx.startLineNumber, id: id, leftExpression: nil)
        } else if let lValueDotCtx = ctx as? MiniParser.LvalueDotContext {
            guard let id = lValueDotCtx.ID()?.getText(),
                let lValue = lValueDotCtx.lvalue(),
                let nestedExpression = visitLValueNested(lValue) else { return nil }
            
            return LValue(lineNumber: lValueDotCtx.startLineNumber,
                          id: id,
                          leftExpression: nestedExpression)
        }
        
        return nil
    }
    
    private func visitLValueNested(_ ctx: MiniParser.LvalueContext) -> Expression? {
        if let lValueIdCtx = ctx as? MiniParser.LvalueIdContext {
            guard let id = lValueIdCtx.ID()?.getText() else { return nil }
            
            return .identifier(lineNumber: lValueIdCtx.startLineNumber, id: id)
        } else if let lValueDotCtx = ctx as? MiniParser.LvalueDotContext {
            guard let id = lValueDotCtx.ID()?.getText(),
                let lValue = lValueDotCtx.lvalue(),
                let nestedExpression = visitLValueNested(lValue) else { return nil }
            
            return .dot(lineNumber: lValueDotCtx.startLineNumber,
                        left: nestedExpression,
                        id: id)
        }
        
        return nil
    }
    
    override func visitPrint(_ ctx: MiniParser.PrintContext) -> Statement? {
        guard let expressionCtx = ctx.expression(),
            let expression = expressionVisitor.visit(expressionCtx) else { return nil }
        
        return .print(lineNumber: ctx.startLineNumber, expression: expression)
    }
    
    override func visitPrintLn(_ ctx: MiniParser.PrintLnContext) -> Statement? {
        guard let expressionCtx = ctx.expression(),
            let expression = expressionVisitor.visit(expressionCtx) else { return nil }
        
        return .printLn(lineNumber: ctx.startLineNumber, expression: expression)
    }
    
    override func visitConditional(_ ctx: MiniParser.ConditionalContext) -> Statement? {
        guard let expressionCtx = ctx.expression(),
            let expression = expressionVisitor.visit(expressionCtx) else { return nil }
        
        guard let thenStatement = visit(ctx.thenBlock) else { return nil }
        
        var elseStatement: Statement?
        if let elseBlock = ctx.elseBlock {
            elseStatement = visit(elseBlock)
        }
        
        
        return .conditional(lineNumber: ctx.startLineNumber,
                            guard: expression,
                            then: thenStatement,
                            else: elseStatement ?? Statement.emptyBlock())
    }
    
    override func visitWhile(_ ctx: MiniParser.WhileContext) -> Statement? {
        guard let expressionCtx = ctx.expression(),
            let expression = expressionVisitor.visit(expressionCtx) else { return nil }
        
        guard let blockContext = ctx.block(),
            let blockStatement = visit(blockContext) else { return nil }
        
        
        return .while(lineNumber: ctx.startLineNumber,
                      guard: expression,
                      body: blockStatement)
    }
    
    override func visitDelete(_ ctx: MiniParser.DeleteContext) -> Statement? {
        guard let expressionCtx = ctx.expression(),
            let expression = expressionVisitor.visit(expressionCtx) else { return nil }
        
        return .delete(lineNumber: ctx.startLineNumber,
                       expression: expression)
    }
    
    override func visitReturn(_ ctx: MiniParser.ReturnContext) -> Statement? {
        var expression: Expression?
        
        if let expressionCtx = ctx.expression() {
            expression = expressionVisitor.visit(expressionCtx)
        }
        
        return .return(lineNumber: ctx.startLineNumber,
                       expression: expression)
    }
    
    override func visitInvocation(_ ctx: MiniParser.InvocationContext) -> Statement? {
        guard let argumentsCtx = ctx.arguments() else { return nil }
        guard let id = ctx.ID()?.getText() else { return nil }
        
        let arguments = argumentsCtx.expression().compactMap {
            expressionVisitor.visit($0)
        }
        
        let invocationExpression = Expression.invocation(lineNumber: ctx.startLineNumber,
                                                         name: id,
                                                         arguments: arguments)
        
        return .invocation(lineNumber: ctx.startLineNumber,
                           expression: invocationExpression)
    }
    
    override func visitStatementList(_ ctx: MiniParser.StatementListContext) -> Statement? {
        let statements = ctx.statement().compactMap {
            visit($0)
        }
        
        return .block(lineNumber: ctx.startLineNumber,
                      statements: statements)
    }
    
    override func visitBlock(_ ctx: MiniParser.BlockContext) -> Statement? {
        guard let statementListCtx = ctx.statementList() else { return nil }
        
        return visit(statementListCtx)
    }
    
    override func defaultResult() -> Statement? {
        Statement.emptyBlock()
    }
}
