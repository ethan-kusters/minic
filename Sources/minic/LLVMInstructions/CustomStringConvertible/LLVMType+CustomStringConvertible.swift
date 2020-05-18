//
//  LLVMType+CustomStringConvertible.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation


extension LLVMType: CustomStringConvertible {
    var description: String {
        switch(self) {
        case .void:
            return "void"
        case .null:
            return "null"
        case .i1:
            return "i1"
        case .i8:
            return "i8"
        case .i32:
            return "i32"
        case .i64:
            return "i64"
        case let .structure(name):
            return "%struct.\(name)*"
        case let .pointer(type):
            return "\(type)*"
        case .label:
            return "label"
        }
    }
}
