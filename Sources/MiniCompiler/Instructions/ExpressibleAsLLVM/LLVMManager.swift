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
        let typeDeclarations = program.types.map {type -> Instruction in
            let types = type.fields.map(\.type.equivalentInstructionType)
            return Instruction.declareStructureType(types: types, result: .structureType(type.name))
        }
        .map(\.llvmString)
        .joined(separator: "\n")
        
        let declarations = program.declarations.map { declaration -> Instruction in
            let type = declaration.type.equivalentInstructionType
            return .declareGlobal(type: declaration.type.equivalentInstructionType,
                                  value: type.unitializedValue,
                                  result: .globalValue(declaration.name, type: type))
        }
        .map(\.llvmString)
        .joined(separator: "\n")
        
        return [typeDeclarations, declarations].joined(separator: "\n")
    }
    
    private func getProgramHeader() -> String {
        let header = "\(LLVMConstants.sourceFilenameHeader)\"\(filename).mini\""
        let target = "\(LLVMConstants.targetHeader)\"x86_64-apple-macosx10.15.0\""
        
        return [header, target, getGlobalDeclarations()].joined(separator: "\n\n")
    }
    
    private func getProgramFooter() -> String {
        return LLVMConstants.predefinedHelperFunctions
    }
    
    func generateLLVM(printOutput: Bool = false) throws {
        let programHeader = getProgramHeader()
        
        let programBody = controlFlowGraphs.map { graph in
            graph.llvmString
        }.joined(separator: "\n")
        
        let programFooter = getProgramFooter()
        
        let outputURL = FileManager.default.currentDirectory
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
