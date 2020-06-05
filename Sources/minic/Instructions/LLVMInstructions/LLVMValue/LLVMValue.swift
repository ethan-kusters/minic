//
//  InstructionValue.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

enum LLVMValue: Hashable {
    case register(LLVMVirtualRegister)
    case literal(Int)
    case null(LLVMType)
    case void
}
