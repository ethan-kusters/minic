//
//  LLVMValue+asRegister.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMValue {
    var asRegister: LLVMVirtualRegister? {
        switch(self) {
        case let .register(register):
            return register
        case .literal,
             .null,
             .void:
            return nil
        }
    }
}
