//
//  main.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/15/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import ArgumentParser
import Foundation

struct minic: ParsableCommand {
    @Argument(help: "The path of the source file to be compiled.") var sourceFilePath: URL
    
    var sourceFileName: String {
        sourceFilePath.deletingPathExtension().lastPathComponent
    }
    
    @Flag(help: "Generate a GraphViz DOT file of the program's control flow graph.")
    var generateCfg: Bool
    
    @Flag(help: "Use GraphViz to generate a PDF of the program's control flow graph.")
    var generateCfgPdf: Bool
    
    @Flag(help: "Print LLVM output instead of outputting to file.")
    var printLlvm: Bool
    
    mutating func validate() throws {
        
        // Verify the file actually exists.
        guard FileManager.default.fileExists(atPath: sourceFilePath.path) else {
            throw ValidationError("File does not exist at \(sourceFilePath.path)")
        }
        
        guard !generateCfgPdf || FileManager.default.isExecutableFile(atPath: GraphVizConstants.dotExecutablePath) else {
            throw ValidationError("Unable to generate CFG PDF without an installatin of dot at \(GraphVizConstants.dotExecutablePath)")
        }
    }
    
    func run() throws {
        let program = try ParsingManager().parseFileAtURL(sourceFilePath)
        
        guard let functionsWithContexts = try TypeCheckingManager().check(program) else { return }
        
        let functionGraphs = functionsWithContexts.map { (function, context) in
            function.getControlFlowGraph(context: context)
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
        
        try llvmManager.generateLLVM(printOutput: printLlvm)
    }
}

minic.main()
