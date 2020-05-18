//
//  Block+llvmIdentifier.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension Block {
    var llvmIdentifier: LLVMIdentifier {
        return .label(label)
    }
}
