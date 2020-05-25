//
//  ARMInstructionConstants.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

struct ARMInstructionConstants {
    static let falseValue: ARMImmediateValue = 0
    static let trueValue: ARMImmediateValue = 1
    static let expectedArchitecture = Architecture._32
    
    static var numberOfBytesPerStructField: Int {
        switch(expectedArchitecture) {
        case ._32:
            return 4
        case ._64:
            return 8
        }
    }
}
