//
//  ARMManager.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

class ARMManager {
    let program: Program
    let controlFlowGraphs: [ARMControlFlowGraph]
    let filename: String
    let codeGenerationContext: CodeGenerationContext
    
    init(_ program: Program, with llvmControlFlowGraphs: [LLVMControlFlowGraph], named filename: String) {
        let codeGenerationContext = CodeGenerationContext()
        
        self.controlFlowGraphs = llvmControlFlowGraphs.map { llvmCFG in
            llvmCFG.getARMControlFlowGraph(withContext: codeGenerationContext)
        }
        
        self.filename = filename
        self.program = program
        self.codeGenerationContext = codeGenerationContext
    }
    
    func generateAssembly(printOutput: Bool = false, outputFilePath: URL? = nil) throws {
        let programInstructions: [ARMInstruction] =
            [
                ARMInstructionMacros.fileHeader,
                program.declarations.map { declaration in
                    ARMInstruction.declareGlobal(label: declaration.name)
                },
                [ARMInstruction.sectionDirective(section: .instructions)],
                controlFlowGraphs.flatMap { graph in
                    graph.instructions
                },
                ARMInstructionMacros.fileFooter
            ].flatten()
        
        let outputURL = (outputFilePath ?? FileManager.default.currentDirectory.appendingPathComponent(filename))
            .appendingPathExtension("s")
        
        let programString = programInstructions.map(\.description).joined(separator: "\n").appending("\n")
        
        if printOutput {
            print(programString)
        } else {
            try programString.write(to: outputURL, atomically: true, encoding: .ascii)
        }
    }
}
