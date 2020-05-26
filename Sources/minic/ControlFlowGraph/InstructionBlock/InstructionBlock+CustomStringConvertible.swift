//
//  InstructionBlock+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension LLVMInstructionBlock: CustomStringConvertible {
    var description: String {
        label
    }
}
