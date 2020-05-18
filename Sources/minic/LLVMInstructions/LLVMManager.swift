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
    
    private func getGlobalDeclarations() -> String {
        let typeDeclarations = program.types.map {type -> String in
            let types = type.fields.map(\.type.llvmType)
            return LLVMInstruction.declareStructureType(target: .structureType(type.name),
                                                        types: types).description
        }
        .joined(separator: "\n")
        
        let declarations = program.declarations.map { declaration -> String in
            let type = declaration.type.llvmType
            return LLVMInstruction.declareGlobal(target: .globalValue(declaration.name,
                                                                           type: type),
                                                 source: type.unitializedValue).description
        }
        .joined(separator: "\n")
        
        return [typeDeclarations, declarations].joined(separator: "\n")
    }
    
    private func getProgramHeader() -> String {
        let header = "\(LLVMStringConstants.sourceFilenameHeader)\"\(filename).mini\""
        let target = "\(LLVMStringConstants.targetHeader)\"x86_64-apple-macosx10.15.0\""
        
        return [header, target, getGlobalDeclarations()].joined(separator: "\n\n")
    }
    
    private func getProgramFooter() -> String {
        return LLVMStringConstants.predefinedHelperFunctions
    }
    
    func generateLLVM(printOutput: Bool = false, outputFilePath: URL? = nil) throws {
        let programHeader = getProgramHeader()
        
        let programBody = controlFlowGraphs.map { graph in
            graph.llvmString
        }.joined(separator: "\n")
        
        let programFooter = getProgramFooter()
        
        let outputURL = outputFilePath ?? FileManager.default.currentDirectory
            .appendingPathComponent(filename)
            .appendingPathExtension("ll")
        
        let programString = [programHeader, programBody, programFooter].joined(separator: "\n\n")
        
        if printOutput {
            print(programString)
        } else {
            try programString.write(to: outputURL, atomically: true, encoding: .ascii)
        }
    }
}
