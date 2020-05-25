//
//  ARMImmediateValue+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMImmediateValue: CustomStringConvertible {
    var description: String {
        "#\(value)"
    }
}
