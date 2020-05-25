//
//  ARMRegister+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMRegister: CustomStringConvertible {
    var description: String {
        switch(self) {
        case let .virtual(virtualLabel):
            return "\(virtualLabel)"
        case let .real(armRegister):
            return armRegister.description
        }
    }
}
