//
//  ARMVirtualRegister+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMVirtualRegister: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
    }
    
    static func == (lhs: ARMVirtualRegister, rhs: ARMVirtualRegister) -> Bool {
        lhs.label == rhs.label
    }
}
