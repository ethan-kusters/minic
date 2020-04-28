//
//  Type+equivalentInstructionType.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension Type {
    var equivalentInstructionType: InstructionType {
        switch(self) {
        case .int:
            return InstructionConstants.defaultIntType
        case .void:
            return .void
        case .struct:
            // TODO: Fixme
            
            return .null
        case .bool:
            return InstructionConstants.defaultBoolType
        }
    }
}
