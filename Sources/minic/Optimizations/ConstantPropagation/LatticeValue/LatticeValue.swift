//
//  RegisterLatticeValue.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

enum LatticeValue: Hashable {
    
    /// ⏉ - the variable is undefined
    case top
    
    /// ⏊ - the value is unknown
    case bottom
    
    /// The variable is a constant
    case constant(Int)
    
    case null
    
    case void
    
}

