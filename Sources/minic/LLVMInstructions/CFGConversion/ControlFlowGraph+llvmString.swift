//
//  ControlFlowGraph+llvmString.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension ControlFlowGraph {
    var llvmString: String {
        let paramString: String
        
        if enableSSA {
            paramString = function.parameters.map { param in
                "\(param.type.llvmType) %\(param.name)"
            }.joined(separator: ", ")
        } else {
            paramString = function.parameters.map { param in
                "\(param.type.llvmType) %\(LLVMInstructionConstants.parameterPrefix)\(param.name)"
            }.joined(separator: ", ")
        }
        
        var llvmString = "define \(function.retType.llvmType) @\(function.name)(\(paramString))"
        llvmString += "\n{"
        
        blocks.forEach { block in
            llvmString += "\n\(block.label):\n\t"
            
            llvmString += block.instructions.map(\.description).joined(separator: "\n\t")
        }
        
        llvmString += "\n}\n"
        
        return llvmString
    }
}
