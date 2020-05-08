//
//  LLVMVirtualRegister+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/8/20.
//

import Foundation

extension LLVMVirtualRegister: CustomStringConvertible {
    var description: String {
        id
    }
}
