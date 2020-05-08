//
//  TypeContext+getInstructionPointer.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension TypeContext {
    func getInstructionPointer(from id: String) -> InstructionIdentifier {
        if let symbol = localSymbolTable?[id] {
            return .localValue(id, type: symbol.equivalentInstructionType)
        } else {
            let symbol = globalSymbolTable[id]!
            return .globalValue(id, type: symbol.equivalentInstructionType)
        }
    }
}
