//
//  CompilerManager.swift
//  minic
//
//  Created by Ethan Kusters on 5/8/20.
//

import Foundation

class CompilerManager {
    static func compile(sourceFile: URL, outputFile: URL? = nil, generateCfg: Bool = false, generateCfgPdf: Bool = false, printLlvm: Bool = false, useSSA: Bool) throws {
        let program = try ParsingManager().parseFileAtURL(sourceFile)
        
        let sourceFileName = sourceFile.deletingPathExtension().lastPathComponent
        
        guard let functionsWithContexts = try TypeCheckingManager().check(program) else { return }
        
        let functionGraphs = functionsWithContexts.map { (function, context) in
            function.getControlFlowGraph(context: context, useSSA: useSSA)
        }
        
        if generateCfgPdf || generateCfg {
            let graphVizManager = GraphVizManager(with: functionGraphs, named: sourceFileName)
            
            if generateCfgPdf {
                try graphVizManager.generateGraphPDF()
            }
            
            if generateCfg {
                try graphVizManager.generateGraphDotfile()
            }
        }
        
        let llvmManager = LLVMManager(program, with: functionGraphs, named: sourceFileName)
        
        try llvmManager.generateLLVM(printOutput: printLlvm, outputFilePath: outputFile)
    }
}
