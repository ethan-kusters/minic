//
//  ARMFlexibleOperand+asRegister.swift
//  minic
//
//  Created by Ethan Kusters on 6/8/20.
//

import Foundation

extension ARMFlexibleOperand {
    var asRegister: ARMRegister? {
        guard case let .register(register) = self else {
            return nil
        }
        
        return register
    }
}
