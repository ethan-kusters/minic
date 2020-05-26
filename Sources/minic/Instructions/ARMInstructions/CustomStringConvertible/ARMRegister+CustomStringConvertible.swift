//
//  ARMRegister+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMRegister: CustomStringConvertible {
    var description: String {
        register.description
    }
}
