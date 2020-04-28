//
//  InstructionValue+ExpressibleAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension InstructionValue: ExpressibleAsLLVM {
    var llvmString: String {
        switch(self) {
        case let .register(register, _):
            return "%\(register)"
        case let .literal(value):
            return String(value)
        }
    }
}
