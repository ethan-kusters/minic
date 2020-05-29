//
//  ARMRealRegister+Comparable.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMRealRegister: Comparable {
    static func < (lhs: ARMRealRegister, rhs: ARMRealRegister) -> Bool {
        lhs.index < rhs.index
    }
}
