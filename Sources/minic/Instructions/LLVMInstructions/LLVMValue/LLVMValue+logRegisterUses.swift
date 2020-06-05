//
//  LLVMValue+logRegisterUses.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMValue {
    func addUse(by instruction: LLVMInstruction) {
        guard case let .register(register) = self else { return }
        register.addUse(by: instruction)
    }
    
    func removeUse(by instruction: LLVMInstruction) {
        guard case let .register(register) = self else { return }
        register.removeUse(by: instruction)
    }
}
