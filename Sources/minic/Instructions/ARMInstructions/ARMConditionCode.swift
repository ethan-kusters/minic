//
//  ARMConditionCode.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

/// ARM conditional code suffixes.
///
/// Instructions that can be conditional have an optional two character condition code suffix.
///
/// # Reference
/// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/condition-codes/condition-code-suffixes)
enum ARMConditionCode: String {
    
    /// Equal
    case EQ
    
    /// Not equal
    case NE
    
    /// Carry set (identical to HS)
    case CS
    
    /// Unsigned higher or same (identical to CS)
    case HS
   
    /// Carry clear (identical to LO)
    case CC
   
    /// Unsigned lower (identical to CC)
    case LO
    
    /// Minus or negative result
    case MI
   
    /// Positive or zero result
    case PL
   
    /// Overflow
    case VS
   
    /// No overflow
    case VC
    
    /// Unsigned higher
    case HI
   
    /// Unsigned lower or same
    case LS
    
    /// Signed greater than or equal
    case GE
    
    /// Signed less than
    case LT
    
    /// Signed greater than
    case GT
    
    /// Signed less than or equal
    case LE
    
    /// Always (this is the default)
    case AL
    
}
