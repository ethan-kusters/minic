//
//  LLVMManager.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

class LLVMManager {
    let program: Program
    let controlFlowGraphs: [ControlFlowGraph]
    let filename: String
    
    init(_ program: Program, with controlFlowGraphs: [ControlFlowGraph], named filename: String) {
        self.program = program
        self.controlFlowGraphs = controlFlowGraphs
        self.filename = filename
    }
    
    private func getProgramHeader() -> String {
        let header = "\(LLVMConstants.sourceFilenameHeader)\"\(filename).mini\""
        let target = "\(LLVMConstants.targetHeader)\"x86_64-apple-macosx10.15.0\""
        let printDeclarations = LLVMConstants.printFunctionDeclarations
        
        return "\(header)\n\(target)\n\n\(printDeclarations)\n\n"
    }
    
    func generateLLVM() throws {
        let programHeader = getProgramHeader()
        
        let programBody = controlFlowGraphs.map { graph in
            graph.llvmString
        }.joined(separator: "\n")
        
        let outputURL = FileManager.default.currentDirectory
            .appendingPathComponent(filename)
            .appendingPathExtension("ll")
        
        try (programHeader + programBody).write(to: outputURL, atomically: true, encoding: .ascii)
    }
}
