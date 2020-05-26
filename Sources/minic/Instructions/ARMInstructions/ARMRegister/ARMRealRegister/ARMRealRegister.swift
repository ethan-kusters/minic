//
//  ARMRealRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

/// ARM processors provide general-purpose and special-purpose registers.
///
/// # Reference
/// [ARM Documentation](
/// https://developer.arm.com/docs/100076/0200/instruction-set-overview/overview-of-aarch32-state/registers-in-aarch32-state)
enum ARMRealRegister: Hashable, ARMRegisterProtocol {
    
    /// `r0-r10`
    case generalPurpose(Int)
    
    /// `r12`
    case intraproceduralScratch
    
    /// `r11`
    case framePointer
    
    /// `sp`
    case stackPointer
    
    /// `lr`
    case linkRegister
    
    /// `pc`
    case programCounter
    
    /// `apsr`
    case applicationProgramStatusRegister
    
}
