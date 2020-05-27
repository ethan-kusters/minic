//
//  ARMFlexibleOperand+addUses.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMFlexibleOperand {
    func addUse(_ instruction: ARMInstruction) {
        switch(self) {
        case let .register(armRegister):
            armRegister.addUse(instruction)
        case .constant:
            return
        }
    }
}
