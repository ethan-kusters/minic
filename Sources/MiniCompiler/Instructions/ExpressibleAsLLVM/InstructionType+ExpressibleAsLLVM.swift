//
//  InstructionType+ExpressibleAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension InstructionType: ExpressibleAsLLVM {
    var llvmString: String {
        self.rawValue
    }
}
