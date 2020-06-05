//
//  LLVMIdentifier+asRegister.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMIdentifier {
    var asRegister: LLVMVirtualRegister? {
        switch(self) {
        case let .virtualRegister(register):
            return register
        case .function,
             .globalValue,
             .structureType,
             .label,
             .null,
             .void:
            return nil
        }
    }
}
