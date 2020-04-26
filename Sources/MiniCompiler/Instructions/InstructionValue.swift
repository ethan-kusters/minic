//
//  InstructionValue.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum InstructionValue: Equatable {
    case register(InstructionRegister)
    case literal(Int)
}
