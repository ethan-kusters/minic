//
//  LLVMValue+identifier.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

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
