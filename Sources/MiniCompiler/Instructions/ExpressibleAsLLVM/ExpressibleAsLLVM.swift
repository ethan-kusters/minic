//
//  ExpressibleAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

protocol ExpressibleAsLLVM {
    var llvmString: String { get }
}
