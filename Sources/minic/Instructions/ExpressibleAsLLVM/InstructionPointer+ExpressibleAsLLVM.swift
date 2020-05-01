//
//  InstructionPointer+ExpressibleAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension InstructionPointer: ExpressibleAsLLVM {
    var llvmString: String {
        switch(self) {
        case let .function(value, _):
            return "@\(value)"
        case let .localValue(value, _):
            return "%\(value)"
        case let .globalValue(value, _):
            return "@\(value)"
        case .null:
            return "null"
        case let .structureType(value):
            return "%struct.\(value)"
        }
    }
}
