//
//  ARMFlexibleOperand.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

/// Flexible second operand
///
/// Many ARM instructions have a flexible second operand
/// that can either be a constant or a register.
///
/// # Documentation
/// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/flexible-second-operand-operand2)
///
/// [ARM immediate value encoding](https://alisdair.mcdiarmid.org/arm-immediate-value-encoding/)
enum ARMFlexibleOperand: Hashable {
    
    /// Any value that can be held in 12 bits. Or any power of 2 from 0 to 31.
    case constant(ARMImmediateValue)
    
    case register(ARMRegister)
    
}

extension ARMFlexibleOperand {
    static let maximumNumberOfBits = 8
    static let maximumValue: Int = Int(pow(Double(maximumNumberOfBits), 2))
    
    static func canHoldValue(_ value: Int) -> Bool {
        return abs(value) < maximumValue
    }
}
