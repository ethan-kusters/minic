//
//  MiniToAstDeclarationsVisitor.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class MiniToAstDeclarationsVisitor: MiniBaseVisitor<[Declaration]> {
    private let typeVisitor = MiniToAstTypeVisitor()
    
    override func visitDeclarations(_ ctx: MiniParser.DeclarationsContext) -> [Declaration]? {
        ctx.declaration().flatMap { declarationCtx -> [Declaration] in
            guard let typeContext = declarationCtx.type(),
                let type = typeVisitor.visit(typeContext) else { return [] }
            
            return declarationCtx.ID().compactMap { node in
                guard let lineNumber = node.getSymbol()?.getLine() else { return nil }
                return Declaration(lineNumber: lineNumber, type: type, name: node.getText())
            }
        }
    }
    
    override func defaultResult() -> [Declaration]? {
        return []
    }
}
