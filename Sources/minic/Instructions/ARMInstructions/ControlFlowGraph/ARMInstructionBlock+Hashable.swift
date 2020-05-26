//
//  ARMInstructionBlock+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstructionBlock: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: ARMInstructionBlock, rhs: ARMInstructionBlock) -> Bool {
        lhs.label == rhs.label
            && lhs.uuid == rhs.uuid
    }
}
