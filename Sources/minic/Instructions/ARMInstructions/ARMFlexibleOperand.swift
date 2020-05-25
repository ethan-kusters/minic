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
enum ARMFlexibleOperand: Hashable {
    case constant(ARMImmediateValue)
    case register(ARMRegister)
}
