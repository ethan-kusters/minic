//
//  InstructionRegister.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

struct VirtualRegister: Equatable {
    private static var currentIndex = 0
    
    let id: String
    
    init() {
        VirtualRegister.currentIndex += 1
        id = "_reg\(VirtualRegister.currentIndex)"
    }
    
    init(withId id: String) {
        self.id = id
    }
}

extension VirtualRegister: CustomStringConvertible {
    var description: String {
        id
    }
}
