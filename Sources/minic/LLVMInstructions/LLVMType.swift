//
//  InstructionType.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMType: Equatable, Hashable {
    case void
    case null
    case i1
    case i8
    case i32
    case i64
    case label
    indirect case pointer(LLVMType)
    case structure(name: String)
}

extension LLVMType {
    var unitializedValue: LLVMValue {
        switch(self) {
        case .i1, .i8, .i32, .i64:
            return .literal(0)
        case .void:
            return .void
        case .null:
            return .null(.null)
        case let .structure(name):
            return .null(.structure(name: name))
        case let .pointer(type):
            return .null(.pointer(type))
        case .label:
            return .void
        }
    }
}
