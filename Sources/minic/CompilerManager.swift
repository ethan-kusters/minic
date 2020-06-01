//
//  CompilerManager.swift
//  minic
//
//  Created by Ethan Kusters on 5/8/20.
//

import Foundation

class CompilerManager {
    static func compile(sourceFile: URL, outputFile: URL? = nil, generateCfg: Bool = false,
                        generateCfgPdf: Bool = false, emitLlvm: Bool = false, printOutput: Bool = false,
                        useSSA: Bool, skipRegisterAllocation: Bool = false) throws {
        let program = try ParsingManager().parseFileAtURL(sourceFile)
        
        let sourceFileName = sourceFile.deletingPathExtension().lastPathComponent
        
        guard let functionsWithContexts = try TypeCheckingManager().check(program) else { return }
        
        let llvmControlFlowGraphs = functionsWithContexts.map { (function, context) in
            function.getLLVMControlFlowGraph(context: context, useSSA: useSSA)
        }
        
        if generateCfgPdf || generateCfg {
            let graphVizManager = GraphVizManager(with: llvmControlFlowGraphs, named: sourceFileName)
            
            if generateCfgPdf {
                try graphVizManager.generateGraphPDF()
            }
            
            if generateCfg {
                try graphVizManager.generateGraphDotfile()
            }
        }
        
        let llvmManager = LLVMManager(program, with: llvmControlFlowGraphs, named: sourceFileName)
        
        if emitLlvm {
            try llvmManager.generateLLVM(printOutput: printOutput, outputFilePath: outputFile)
        } else {
            let armManager = ARMManager(program,
                                        with: llvmControlFlowGraphs,
                                        named: sourceFileName,
                                        skipRegisterAllocation: skipRegisterAllocation)
            
            try armManager.generateAssembly(printOutput: printOutput, outputFilePath: outputFile)
        }
    }
}
