//
//  LLVMVirtualRegister.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

struct LLVMVirtualRegister: Equatable {
    private static var currentIndex = 0
    
    private let id: String
    let type: LLVMType
    
    var identifier: LLVMIdentifier {
        .localValue(id, type: type)
    }
    
    init(ofType type: LLVMType) {
        LLVMVirtualRegister.currentIndex += 1
        id = "_reg\(LLVMVirtualRegister.currentIndex)"
        self.type = type
    }
    
    init(withId id: String, type: LLVMType) {
        self.id = id
        self.type = type
    }
    
    static func newIntRegister() -> LLVMVirtualRegister {
        LLVMVirtualRegister(ofType: LLVMInstructionConstants.defaultIntType)
    }
    
    static func newBoolRegister() -> LLVMVirtualRegister {
        LLVMVirtualRegister(ofType: LLVMInstructionConstants.defaultBoolType)
    }
}
