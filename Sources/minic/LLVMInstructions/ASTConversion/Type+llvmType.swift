//
//  Type+llvmType.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension Type {
    var llvmType: LLVMType {
        switch(self) {
        case .int:
            return LLVMInstructionConstants.defaultIntType
        case .void:
            return .void
        case let .struct(_, name):
            return .structure(name: name)
        case .bool:
            return LLVMInstructionConstants.defaultIntType
        case .null:
            return .null
        }
    }
}
