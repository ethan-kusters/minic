//
//  ARMRealRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

/// Arm processors provide general-purpose and special-purpose registers.
///
/// # Reference
/// [ARM Documentation](https://developer.arm.com/docs/100076/0200/instruction-set-overview/overview-of-aarch32-state/registers-in-aarch32-state)
enum ARMRealRegister: Hashable {
    
    /// # Syntax
    /// `r0-r10`
    case generalPurpose(Int)
    
    /// # Syntax
    /// `r12`
    case intraproceduralScratch
    
    /// # Syntax
    /// `r11`
    case framePointer
    
    /// # Syntax
    /// `sp`
    case stackPointer
    
    /// # Syntax
    /// `lr`
    case linkRegister
    
    /// # Syntax
    /// `pc`
    case programCounter
    
    /// # Syntax
    /// `apsr`
    case applicationProgramStatusRegister
    
}
