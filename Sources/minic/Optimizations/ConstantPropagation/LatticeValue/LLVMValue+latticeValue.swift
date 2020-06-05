//
//  LLVMValue+latticeValue.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMValue {
    func getLatticeValue(_ mapping: LatticeMapping) -> LatticeValue {
        switch(self) {
        case let .register(register):
            return mapping[register]!
        case let .literal(value):
            return .constant(value)
        case .null:
            return .null
        case .void:
            return .void
        }
    }
}
