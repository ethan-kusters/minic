//
//  MiniToAstTypeDeclarationVisitor.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class MiniToAstTypeDeclarationVisitor: MiniBaseVisitor<TypeDeclaration> {
    let typeVisitor = MiniToAstTypeVisitor()
    
    override func visitTypeDeclaration(_ ctx: MiniParser.TypeDeclarationContext) -> TypeDeclaration? {
        guard let id = ctx.ID()?.getText() else { return nil }
        
        guard let nestedDeclCtx = ctx.nestedDecl() else { return nil }
        let fieldDeclarations = nestedDeclCtx.decl().compactMap { nestedDecl -> Declaration? in
            guard let typeCtx = nestedDecl.type(),
                let type = typeVisitor.visit(typeCtx) else { return nil }
            
            guard let id = nestedDecl.ID()?.getText() else { return nil }
            
            return Declaration(lineNumber: typeCtx.startLineNumber,
                               type: type,
                               name: id)
        }
        
        return TypeDeclaration(lineNumber: ctx.startLineNumber,
                               name: id,
                               fields: fieldDeclarations)
    }
    
    override func defaultResult() -> TypeDeclaration? {
        TypeDeclaration(lineNumber: -1, name: "invalid", fields: [])
    }
}
