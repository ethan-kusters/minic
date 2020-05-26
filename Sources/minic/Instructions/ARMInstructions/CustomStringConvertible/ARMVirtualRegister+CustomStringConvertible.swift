//
//  ARMVirtualRegister+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMVirtualRegister: CustomStringConvertible {
    var description: String {
        label
    }
}
