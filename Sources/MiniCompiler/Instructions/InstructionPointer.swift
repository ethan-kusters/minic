//
//  InstructionPointer.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum InstructionPointer: Equatable {
    case function(String)
    case value(String)
    case label(String)
}
