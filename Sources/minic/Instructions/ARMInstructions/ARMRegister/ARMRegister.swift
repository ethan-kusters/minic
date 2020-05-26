//
//  ARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

class ARMRegister {
    let register: ARMRegisterProtocol
    let uuid = UUID()
    var uses = Set<ARMInstruction>()
    var definitions = Set<ARMInstruction>()
    
    var flexibleOperand: ARMFlexibleOperand {
        .register(self)
    }
    
    init(_ register: ARMRegisterProtocol) {
        self.register = register
    }
}
