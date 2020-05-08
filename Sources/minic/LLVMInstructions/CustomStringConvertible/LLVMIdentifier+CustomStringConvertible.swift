//
//  LLVMIdentifier+CustomStringConvertible.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension LLVMIdentifier: CustomStringConvertible {
    var description: String {
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
        case let .label(value):
            return "label %\(value)"
        case .void:
            return "void"
        }
    }
}
