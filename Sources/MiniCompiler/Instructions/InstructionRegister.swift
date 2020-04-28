//
//  InstructionRegister.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

struct InstructionRegister: Equatable {
    private static var currentIndex = 0
    
    let id: String
    
    init() {
        InstructionRegister.currentIndex += 1
        id = "_reg\(InstructionRegister.currentIndex)"
    }
    
    init(withId id: String) {
        self.id = id
    }
}

extension InstructionRegister: CustomStringConvertible {
    var description: String {
        id
    }
}
