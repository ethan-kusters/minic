//
//  InstructionConditionCode.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

/// Used as an argument to the `icmp` instruction
///
/// # Reference
/// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#id300)
enum LLVMConditionCode: String, Hashable {
    
    /// equal
    case eq
    
    /// not equal
    case ne
    
    /// signed greater than
    case sgt
    
    /// signed greater or equal
    case sge
    
    /// signed less than
    case slt
    
    /// signed less or equal
    case sle
    
}
