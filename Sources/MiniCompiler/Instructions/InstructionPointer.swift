//
//  InstructionPointer.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum InstructionPointer: Equatable {
    case function(String, retType: InstructionType)
    case localValue(String, type: InstructionType)
    case globalValue(String, type: InstructionType)
    case structureType(String)
    case null
}

extension InstructionPointer {
    var type: InstructionType {
        switch(self) {
        case let .function(_, retType):
            return retType
        case let .localValue(_, type):
            return type
        case let .globalValue(_, type):
            return type
        case .null:
            return .null
        case let .structureType(name):
            return .structure(name: name)
        }
    }
}
