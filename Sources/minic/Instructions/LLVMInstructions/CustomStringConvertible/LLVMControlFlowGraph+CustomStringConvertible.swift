//
//  LLVMControlFlowGraph+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

extension LLVMControlFlowGraph: CustomStringConvertible {
    var description: String {
        let paramString: String
        
        if ssaEnabled {
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
