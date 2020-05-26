//
//  ARMRegister+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMRegister: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: ARMRegister, rhs: ARMRegister) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
