//
//  Type.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

enum Type {
    case int
    case void
    case `struct` (lineNumber: Int, name: String)
    case bool
}

extension Type: Equatable {
    public static func == (lhs: Type, rhs:Type) -> Bool {
        switch(lhs, rhs) {
        case(.int, .int):
            return true
        case (.void, .void):
            return true
        case (.struct, .struct):
            return true
        case (.bool, .bool):
            return true
        case (_, _):
            return false
        }
    }
}

extension Type: CustomStringConvertible {
    var description: String {
        switch(self) {
        case .int:
            return "int"
        case .bool:
            return "bool"
        case .struct(lineNumber: _, name: let name):
            return "struct \(name)"
        case .void:
            return "void"
        }
    }
}

