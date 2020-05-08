//
//  InstructionValue.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMValue: Equatable {
    case register(LLVMVirtualRegister)
    case null(LLVMType)
    case void
    case literal(Int)
}

extension LLVMValue {
    var type: LLVMType {
        switch(self) {
        case let .register(register):
            return register.type
        case .literal:
            return LLVMInstructionConstants.defaultIntType
        case let .null(type):
            return type
        case .void:
            return .void
        }
        
    }
}

extension LLVMValue {
    static func existingRegister(withId id: String, type: LLVMType) -> LLVMValue {
        .register(LLVMVirtualRegister(withId: id, type: type))
    }
    
    var identifier: String {
        switch(self) {
        case let .register(register):
            return register.id
        case let .literal(val):
            return val.description
        case .null:
            return "null"
        case .void:
            return "void"
        }
    }
}

extension LLVMValue {
    var llvmIdentifier: LLVMIdentifier {
        switch(self) {
        case let .register(register):
            return .localValue(register.id, type: register.type)
        case let .null(type):
            return .null(type)
        case .void:
            return .void
        case .literal:
            fatalError("Literal values cannot be converted to identifiers.")
        }
    }
}
