//
//  InstructionType.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum InstructionType: Equatable {
    case void
    case null
    case i1
    case i8
    case i32
    case i64
    indirect case pointer(InstructionType)
    case structure(name: String)
}

extension InstructionType {
    var unitializedValue: InstructionValue {
        switch(self) {
        case .i1, .i8, .i32, .i64:
            return .literal(0)
        case .void:
            return .null(type: .void)
        case .null:
            return .null(type: .null)
        case let .structure(name):
            return .null(type: .structure(name: name))
        case let .pointer(type):
            return .null(type: .pointer(type))
        }
    }
}
