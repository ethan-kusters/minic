//
//  InstructionPointer.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMIdentifier: Equatable, Hashable {
    
    case function(String, retType: LLVMType)
    
    case localValue(String, type: LLVMType)
    
    case globalValue(String, type: LLVMType)
    
    case structureType(String)
    
    case label(String)
    
    case null(LLVMType)
    
    case void

}

extension LLVMIdentifier {
    var type: LLVMType {
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
            case .label:
                return .label
            case .void:
                return .void
        }
    }
}
