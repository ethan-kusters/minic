//
//  LLVMVirtualRegister+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMVirtualRegister: Hashable {
    static func == (lhs: LLVMVirtualRegister, rhs: LLVMVirtualRegister) -> Bool {
        lhs.rawIdentifier == rhs.rawIdentifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawIdentifier)
        hasher.combine(type)
    }
}
