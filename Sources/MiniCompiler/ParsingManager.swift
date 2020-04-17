//
//  File.swift
//  
//
//  Created by Ethan Kusters on 4/14/20.
//

import Foundation
import Antlr4

class ParsingManager {
    func parseFileAtURL(_ url: URL) throws -> Program {
        let input = try ANTLRFileStream(url.path, String.Encoding.utf8)
        let miniLexer = MiniLexer(input)
        let tokens = CommonTokenStream(miniLexer)
        let parser = try MiniParser(tokens)
        let tree = try parser.program()
        let programVisitor = MiniToAstProgramVisitor()
        return programVisitor.visit(tree)!
    }
}
