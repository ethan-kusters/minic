//
//  ARMRealRegister+ExpressibleByIntegerLiteral.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension ARMRealRegister: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self = .generalPurpose(value)
    }
}
