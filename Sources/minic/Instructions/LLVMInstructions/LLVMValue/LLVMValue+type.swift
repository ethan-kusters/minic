//
//  LLVMValue+type.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

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
