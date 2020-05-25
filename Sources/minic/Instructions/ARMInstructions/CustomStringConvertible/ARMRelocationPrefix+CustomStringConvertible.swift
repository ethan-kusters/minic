//
//  ARMRelocationPrefix+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMRelocationPrefix: CustomStringConvertible {
    var description: String {
        switch(self) {
        case .lower16:
            return ":lower16:"
        case .upper16:
            return ":upper16:"
        }
    }
}
