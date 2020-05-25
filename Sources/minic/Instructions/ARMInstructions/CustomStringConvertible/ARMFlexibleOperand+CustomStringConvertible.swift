//
//  ARMFlexibleOperand+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMFlexibleOperand: CustomStringConvertible {
    var description: String {
        switch(self) {
        case let .constant(immediateValue):
            return immediateValue.description
        case let .register(armRegister):
            return armRegister.description
        }
    }
}
