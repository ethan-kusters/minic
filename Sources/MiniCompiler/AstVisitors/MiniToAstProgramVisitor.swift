//
//  MiniToAstProgramVisitor.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class MiniToAstProgramVisitor: MiniBaseVisitor<Program> {
    private let typeDeclarationsVisitor = MiniToAstTypeDeclarationVisitor()
    private let declarationsVisitor = MiniToAstDeclarationsVisitor()
    private let functionVisitor = MiniToAstFunctionVisitor()
    
    override func visitProgram(_ ctx: MiniParser.ProgramContext) -> Program? {
        guard let typesCtx = ctx.types() else { return nil }
        let typeDeclarations = typesCtx.typeDeclaration().compactMap {
            typeDeclarationsVisitor.visit($0)
        }
        
        guard let declarationsCtx = ctx.declarations() else { return nil }
        guard let declarations = declarationsVisitor.visit(declarationsCtx) else { return nil }
        
        guard let functionsCtx = ctx.functions() else { return nil }
        let functions = functionsCtx.function().compactMap {
            functionVisitor.visit($0)
        }
        
        return Program(types: typeDeclarations, declarations: declarations, functions: functions)
    }
}
