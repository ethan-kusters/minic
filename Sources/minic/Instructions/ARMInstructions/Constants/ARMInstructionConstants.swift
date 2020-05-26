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
    static let nullValue: ARMImmediateValue = 0
    
    static let expectedARMArchitecture = ARMArchitecture.ARMv7A
    
    static var expectedProcessorArchitecture: Architecture {
        switch(expectedARMArchitecture) {
        case .ARMv7A:
            return ._32
        }
    }
    
    static let byteAlignment = 4
    static let byteAlignmentExponent = 2
    
    static var bytesPerValue: Int {
        switch(expectedProcessorArchitecture) {
        case ._32:
            return 4
        case ._64:
            return 8
        }
    }
}
