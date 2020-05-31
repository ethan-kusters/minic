//
//  ARMRegisterCollection+firstUnconstrainedNode.swift
//  minic
//
//  Created by Ethan Kusters on 5/30/20.
//

import Foundation

extension Set where Element == ARMRegister {
    mutating func removeFirstUnconstrainedNode() -> ARMRegister? {
         guard let node = first(where: { element in
            (element.interferingRegisters.count < ARMInstructionConstants.availableRegisters.count)
                && (element.register is ARMVirtualRegister)
         }) else { return nil }
        
        remove(node)
        return node
    }
}
