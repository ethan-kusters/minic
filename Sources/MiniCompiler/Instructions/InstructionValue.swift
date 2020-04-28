//
//  InstructionValue.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum InstructionValue: Equatable {
    case register(register: InstructionRegister, type: InstructionType)
    case literal(Int)
}

extension InstructionValue {
    var type: InstructionType {
        switch(self) {
        case let .register(_, type):
            return type
        case .literal:
            return InstructionConstants.defaultIntType
        }
        
    }
}

extension InstructionValue {
    static func newIntRegister() -> InstructionValue {
        return .register(register: InstructionRegister(), type: InstructionConstants.defaultIntType)
    }
    
    static func newBoolRegister() -> InstructionValue {
        return .register(register: InstructionRegister(), type: InstructionConstants.defaultBoolType)
    }
    
    static func newRegister(forType type: InstructionType) -> InstructionValue {
        .register(register: InstructionRegister(), type: type)
    }
    
    static func existingRegister(withId id: String, type: InstructionType) -> InstructionValue {
        .register(register: InstructionRegister(withId: id), type: type)
    }
}
