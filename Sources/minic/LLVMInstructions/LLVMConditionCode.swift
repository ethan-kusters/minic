//
//  InstructionConditionCode.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

/// Used as an argument to the `icmp` instruction
enum LLVMConditionCode: String, Equatable {
    
    /// equal
    case eq
    
    /// not equal
    case ne
    
    /// unsigned greater than
    case ugt
    
    /// unsigned greater or equal
    case uge
    
    /// unsigned less than
    case ult
    
    /// unsigned less or equal
    case ule
    
    /// signed greater than
    case sgt
    
    /// signed greater or equal
    case sge
    
    /// signed less than
    case slt
    
    /// signed less or equal
    case sle
}
