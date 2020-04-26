//
//  InstructionArgument.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

struct InstructionArgument: Equatable {
    let type: InstructionType
    let value: InstructionValue
}
