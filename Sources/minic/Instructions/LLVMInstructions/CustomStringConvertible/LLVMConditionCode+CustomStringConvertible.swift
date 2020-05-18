//
//  LLVMConditionCode+CustomStringConvertible.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension LLVMConditionCode: CustomStringConvertible {
    var description: String {
        self.rawValue
    }
}
