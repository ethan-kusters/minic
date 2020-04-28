//
//  ControlFlowGraph+ExpressibleAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension ControlFlowGraph: ExpressibleAsLLVM {
    var llvmString: String {
        let paramString = function.parameters.map { param in
            param.type.equivalentInstructionType.llvmString + " %\(InstructionConstants.parameterPrefix)\(param.name)"
        }.joined(separator: ", ")
        
        var llvmString = "define \(function.retType.equivalentInstructionType.llvmString) @\(function.name)(\(paramString))"
        llvmString += "\n{"
        
        blocks.forEach { block in
            llvmString += "\n\(block.label):\n\t"
            llvmString += block.instructions.map(\.llvmString).joined(separator: "\n\t")
        }
        
        llvmString += "\n}\n"
        
        return llvmString
    }
}
