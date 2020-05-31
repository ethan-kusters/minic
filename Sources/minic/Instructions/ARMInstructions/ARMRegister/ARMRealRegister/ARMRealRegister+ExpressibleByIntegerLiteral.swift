//
//  ARMRealRegister+ExpressibleByIntegerLiteral.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension ARMRealRegister: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        guard (0...10).contains(value) else {
            fatalError("General purpose registers must be in the range of r0 through r10.")
        }
        
        self = .generalPurpose(value)
    }
}
