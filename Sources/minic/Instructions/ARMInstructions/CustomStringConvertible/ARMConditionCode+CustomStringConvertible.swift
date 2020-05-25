//
//  ARMConditionCode+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMConditionCode: CustomStringConvertible {
    var description: String {
        self.rawValue
    }
}
