//
//  ARMArchitecture+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

extension ARMArchitecture: CustomStringConvertible {
    var description: String {
        switch(self) {
        case .ARMv7A:
            return "armv7-a"
        }
    }
}
