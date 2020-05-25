//
//  Int+immediateValue.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension IntegerLiteralType {
    var immediateValue: ARMImmediateValue {
        ARMImmediateValue(integerLiteral: self)
    }
}
