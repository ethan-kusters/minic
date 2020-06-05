//
//  LLVMIdentifier+logRegisterUses.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMIdentifier {
    func setDefiningInstruction(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.setDefiningInstruction(instruction)
    }
    
    func removeDefiningInstruction(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.removeDefiningInstruction(instruction)
    }
    
    func addUse(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.addUse(by: instruction)
    }
    
    func removeUse(_ instruction: LLVMInstruction) {
        guard case let .virtualRegister(register) = self else { return }
        register.removeUse(by: instruction)
    }
}
