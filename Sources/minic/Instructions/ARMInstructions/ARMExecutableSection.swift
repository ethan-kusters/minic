//
//  ARMExecutableSection.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

/// Used by section directives that instruct the assembler
/// to change the ELF section that code and data is being emitted into.
///
/// # Reference
/// [ARM Documentation](https://developer.arm.com/docs/dui0774/i/armclang-integrated-assembler-directives/section-directives)
///
/// [Wikipedia Article](https://en.wikipedia.org/wiki/Data_segment)
enum ARMExecutableSection: Hashable {
    
    /// A custom named section.
    ///
    /// # Syntax
    /// `.section name`
    case named(String)
    
    /// Section that holds executable instructions.
    ///
    /// # Syntax
    /// `.text`
    case instructions
    
    /// Contains global variables that can be modified.
    ///
    /// # Syntax
    /// `.data`
    case data
    
    /// Holds read-only data. Constant global and static variables.
    ///
    /// # Syntax
    /// `.rodata`
    case readOnlyData
    
    /// Holds unitialized data, both variables and constants.
    ///
    /// # Syntax
    /// `.bss`
    case uninitializedData
    
}
