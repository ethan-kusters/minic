//
//  LLVMVirtualRegister+armRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/21/20.
//

import Foundation

extension LLVMVirtualRegister {
    var armRegister: ARMRegister {
        return .virtual(self)
    }
}
