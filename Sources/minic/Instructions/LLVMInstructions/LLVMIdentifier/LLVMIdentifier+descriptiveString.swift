//
//  LLVMIdentifier+descriptiveString.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMIdentifier {
    var descriptiveString: String {
        switch(self) {
        case let .function(id, _):
            return "function_\(id)"
        case let .virtualRegister(register):
            return register.rawIdentifier
        case let .globalValue(id, _):
            return "global_\(id)"
        case let .structureType(id):
            return "structure_\(id)"
        case let .label(id):
            return "label_\(id)"
        case let .null(type):
            return "nullOfType_\(type)"
        case .void:
            return "void"
        }
    }
}
