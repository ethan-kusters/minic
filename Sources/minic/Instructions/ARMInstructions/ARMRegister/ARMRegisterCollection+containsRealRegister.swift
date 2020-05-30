//
//  ARMRegisterCollection+containsRealRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/30/20.
//

import Foundation

extension Collection where Element == ARMRegister {
    var containsRealRegister: Bool {
        contains { element in
            element.register is ARMRealRegister
        }
    }
    
    var firstRealRegister: ARMRealRegister? {
        first(where: { element in
            element.register is ARMRealRegister
        })?.register as? ARMRealRegister
    }
}
