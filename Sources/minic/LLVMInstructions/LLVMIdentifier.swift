//
//  InstructionPointer.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMIdentifier: Equatable, Hashable {
    
    case function(String, retType: LLVMType)
    
    case localValue(String, type: LLVMType)
    
    case globalValue(String, type: LLVMType)
    
    case structureType(String)
    
    case label(String)
    
    case null(LLVMType)
    
    case void

}

extension LLVMIdentifier {
    var type: LLVMType {
        switch(self) {
            case let .function(_, retType):
                return retType
            case let .localValue(_, type):
                return type
            case let .globalValue(_, type):
                return type
            case .null:
                return .null
            case let .structureType(name):
                return .structure(name: name)
            case .label:
                return .label
            case .void:
                return .void
        }
    }
}

extension LLVMIdentifier {
    var descriptiveString: String {
        switch(self) {
        case let .function(id, _):
            return "function_\(id)"
        case let .localValue(id, _):
            return "local_\(id)"
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
