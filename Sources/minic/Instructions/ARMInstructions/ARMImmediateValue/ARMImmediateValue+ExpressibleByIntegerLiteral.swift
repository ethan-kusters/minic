//
//  ARMImmediateValue+ExpressibleByIntegerLiteral.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMImmediateValue: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}
