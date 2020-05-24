//
//  LLVMIdentifier.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMIdentifier: Equatable, Hashable {
    
    case function(String, retType: LLVMType)
    
    case virtualRegister(LLVMVirtualRegister)
    
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
        case let .virtualRegister(register):
                return register.type
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

extension LLVMIdentifier {
    static func == (lhs: LLVMIdentifier, rhs: LLVMVirtualRegister) -> Bool {
        guard case let .virtualRegister(lhsRegister) = lhs else { return false }
        return lhsRegister == rhs
    }
}

extension LLVMIdentifier {
    func setDefiningInstruction(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.setDefiningInstruction(instruction)
    }
    
    func removeDefiningInstruction(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.removeDefiningInstruction(instruction)
    }
    
    func addUse(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.addUse(by: instruction)
    }
    
    func removeUse(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.removeUse(by: instruction)
    }
}
