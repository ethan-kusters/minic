//
//  ARMExpression.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

/// Expressions consist of one or more integer literals
/// or symbol references, combined using operators.
///
/// # Reference
/// [ARM Documentation](https://developer.arm.com/docs/100067/0610/armclang-integrated-assembler-directives/assembly-expressions)
enum ARMExpression: Hashable {
    
    case literal(prefix: ARMRelocationPrefix?, immediate: ARMImmediateValue)
    
    case symbol(prefix: ARMRelocationPrefix?, symbol: ARMSymbol)
    
}
