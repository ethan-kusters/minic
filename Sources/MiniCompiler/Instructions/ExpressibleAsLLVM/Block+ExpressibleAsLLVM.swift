//
//  Block+ExpressibleAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension Block: ExpressibleAsLLVM {
    var llvmString: String {
        return "%\(label)"
    }
}
