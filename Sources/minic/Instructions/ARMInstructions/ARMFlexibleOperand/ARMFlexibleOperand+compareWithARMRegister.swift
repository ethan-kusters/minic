//
//  ARMFlexibleOperand+compareWithARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/30/20.
//

import Foundation

extension ARMFlexibleOperand {
    static func == (lhs: ARMRegister, rhs: ARMFlexibleOperand) -> Bool {
        guard case let .register(rhsReg) = rhs else { return false }
        return lhs == rhsReg
    }
    
    
    static func != (lhs: ARMRegister, rhs: ARMFlexibleOperand) -> Bool {
        return !(lhs == rhs)
    }
}
