//
//  Program.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

struct Program {
    let types: [TypeDeclaration]
    let declarations: [Declaration]
    let functions: [Function]
}
