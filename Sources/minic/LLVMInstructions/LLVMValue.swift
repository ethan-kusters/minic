//
//  InstructionValue.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMValue: Hashable {
    case register(LLVMVirtualRegister)
    case literal(Int)
    case null(LLVMType)
    case void
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
    var identifier: LLVMIdentifier {
        switch(self) {
        case let .register(register):
            return register.identifier
        case let .null(type):
            return .null(type)
        case .void:
            return .void
        case .literal:
            fatalError("Literal values cannot be converted to identifiers.")
        }
    }
}

extension LLVMValue {
    func addUse(by instruction: LLVMInstruction) {
        guard case let .register(register) = self else { return }
        register.addUse(by: instruction)
    }
}

extension LLVMValue {
    static func == (lhs: LLVMValue, rhs: LLVMVirtualRegister) -> Bool {
        guard case let .register(lhsRegister) = lhs else { return false }
        return lhsRegister == rhs
    }
}
