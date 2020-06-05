//
//  LLVMVirtualRegister+latticeValue.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMVirtualRegister {
    func getLatticeValue(_ mapping: LatticeMapping) -> LatticeValue {
        return mapping[self]!
    }
}
