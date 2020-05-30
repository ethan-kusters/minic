//
//  ARMRegisterCollection+firstUnconstrainedNode.swift
//  minic
//
//  Created by Ethan Kusters on 5/30/20.
//

import Foundation

extension Collection where Element == ARMRegister {
    var firstUnconstrainedNode: ARMRegister? {
        first(where: { element in
            (element.interferingRegisters.count < ARMInstructionConstants.availableRegisters.count)
                && (element.register is ARMVirtualRegister)
        })
    }
}
