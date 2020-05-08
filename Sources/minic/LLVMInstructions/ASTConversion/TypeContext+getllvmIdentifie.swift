//
//  TypeContext+getllvmIdentifier.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension TypeContext {
    func getllvmIdentifier(from id: String) -> LLVMIdentifier {
        if let symbol = localSymbolTable?[id] {
            return .localValue(id, type: symbol.llvmType)
        } else {
            let symbol = globalSymbolTable[id]!
            return .globalValue(id, type: symbol.llvmType)
        }
    }
}
