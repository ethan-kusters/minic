//
//  Function.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

struct Function {
    let lineNumber: Int
    let name: String
    let retType: Type
    let parameters: [Declaration]
    let locals: [Declaration]
    let body: Statement
}
