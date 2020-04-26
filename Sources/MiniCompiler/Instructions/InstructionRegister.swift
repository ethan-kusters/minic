//
//  InstructionRegister.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

struct InstructionRegister: Equatable {
    private static var currentIndex = 0
    
    let index: Int
    
    init() {
        InstructionRegister.currentIndex += 1
        index = InstructionRegister.currentIndex
    }
}
