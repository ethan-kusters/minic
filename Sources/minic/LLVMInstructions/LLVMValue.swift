//
//  InstructionValue.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMValue: Equatable {
    case register(register: VirtualRegister, type: LLVMType)
    case literal(Int)
    case null(type: LLVMType)
    case void
}

extension LLVMValue {
    var type: LLVMType {
        switch(self) {
        case let .register(_, type):
            return type
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
    static func newIntRegister() -> LLVMValue {
        return .register(register: VirtualRegister(), type: LLVMInstructionConstants.defaultIntType)
    }
    
    static func newBoolRegister() -> LLVMValue {
        return .register(register: VirtualRegister(), type: LLVMInstructionConstants.defaultBoolType)
    }
    
    static func newRegister(forType type: LLVMType) -> LLVMValue {
        .register(register: VirtualRegister(), type: type)
    }
    
    static func existingRegister(withId id: String, type: LLVMType) -> LLVMValue {
        .register(register: VirtualRegister(withId: id), type: type)
    }
    
    var identifier: String {
        switch(self) {
        case let .register(register, _):
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
