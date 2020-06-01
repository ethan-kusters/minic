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
    
    @Option(name: .shortAndLong, help: "The path of the destination file.") var outputFilePath: URL?
    
    @Flag(help: "Generate a GraphViz DOT file of the program's control flow graph.")
    var generateCfg: Bool
    
    @Flag(help: "Favor the stack and disable the use of static single assignment")
    var disableSSA: Bool
    
    @Flag(help: "Use GraphViz to generate a PDF of the program's control flow graph.")
    var generateCfgPdf: Bool
    
    @Flag(help: "Print output instead of outputting to file.")
    var printOutput: Bool
    
    @Flag(help: "Emit LLVM code instead of ARM assembly.")
    var emitLlvm: Bool
    
    @Flag(help: "Skips the register allocation phase of generating ARM.")
    var skipRegisterAllocation: Bool
    
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
        try CompilerManager.compile(sourceFile: sourceFilePath,
                                    outputFile: outputFilePath?.deletingPathExtension(),
                                    generateCfg: generateCfg,
                                    generateCfgPdf: generateCfgPdf,
                                    emitLlvm: emitLlvm,
                                    printOutput: printOutput,
                                    useSSA: !disableSSA,
                                    skipRegisterAllocation: skipRegisterAllocation)
    }
}

minic.main()
