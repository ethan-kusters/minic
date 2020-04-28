//
//  Function+ExpressibleAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension Function: ExpressibleAsLLVM {
    var llvmString: String {
        
        return "define \(retType.equivalentInstructionType.llvmString) @\(name)("
    }
}
