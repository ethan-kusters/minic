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
    case null (typeIndex: Int)
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
        case let (.struct(lineNumber, name), .null(typeIndex)):
            NullTypeManager.setNullType(forIndex: typeIndex,
                                        asType: .struct(lineNumber: lineNumber, name: name))
            
            return true
        case let (.null(typeIndex), .struct(lineNumber, name)):
            NullTypeManager.setNullType(forIndex: typeIndex,
                                        asType: .struct(lineNumber: lineNumber, name: name))
            
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
        case .null:
            return "null"
        case .void:
            return "void"
        }
    }
}

