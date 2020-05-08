//
//  MiniToAstFunctionVisitor.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class MiniToAstFunctionVisitor: MiniBaseVisitor<Function> {
    private let typeVisitor = MiniToAstTypeVisitor()
    private let declarationVisitor = MiniToAstDeclarationsVisitor()
    private let statementVisitor = MiniToAstStatementVisitor()
    
    override func visitFunction(_ ctx: MiniParser.FunctionContext) -> Function? {
        guard let id = ctx.ID()?.getText() else { return nil }
        guard let parametersCtx = ctx.parameters() else { return nil }
        
        guard let retTypeCtx = ctx.returnType(),
            let retType = typeVisitor.visit(retTypeCtx) else { return nil }
        
        let parameters = parametersCtx.decl().compactMap { declarationCtx -> Declaration? in
            guard let typeCtx = declarationCtx.type(),
                let type = typeVisitor.visit(typeCtx) else { return nil }

            guard let id = declarationCtx.ID()?.getText() else { return nil }
            return Declaration(lineNumber: declarationCtx.startLineNumber, type: type, name: id)
        }
        
        
        
        guard let declarationsCtx = ctx.declarations(),
            let declarations = declarationVisitor.visit(declarationsCtx) else { return nil }
        
        guard let statementCtx = ctx.statementList(),
            let bodyStatement = statementVisitor.visit(statementCtx) else { return nil }
        
        return Function(lineNumber: ctx.startLineNumber,
                        name: id,
                        retType: retType,
                        parameters: parameters,
                        locals: declarations,
                        body: bodyStatement)
    }
    
    override func defaultResult() -> Function? {
        Function(lineNumber: -1,
                 name: "invalid",
                 retType: .void,
                 parameters: [],
                 locals: [],
                 body: Statement.emptyBlock())
    }
}
