//
//  ARMRelocationPrefix.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

/// For some instruction operands, a relocation specifier
/// might be used to specify which bits of the expression
/// should be used for the operand, and which type of relocation should be used.
///
/// These relocation specifiers are only valid for the operands
/// of the `movw` and `movt` instructions. 
///
/// # Reference
/// [ARM Documentation](
/// http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0774i/zvb1510926525383.html)
///
/// [AS Documentation](http://sourceware.org/binutils/docs-2.34/as/ARM_002dRelocations.html)
enum ARMRelocationPrefix {
    
    /// Use the lower 16 bits of the expression value.
    case lower16
    
    /// Use the upper 16 bits of the expression value.
    case upper16
    
}
