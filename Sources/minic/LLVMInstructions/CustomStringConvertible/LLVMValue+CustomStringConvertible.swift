//
//  LLVMValue+CustomStringConvertible.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension LLVMValue: CustomStringConvertible {
    var description: String {
        switch(self) {
        case let .register(register):
            return register.description
        case let .literal(value):
            return String(value)
        case .null:
            return "null"
        case .void:
            return "void"
        }
    }
}
