//
//  TypeDeclaration.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

struct TypeDeclaration {
    let lineNumber: Int
    let name: String
    let fields: [Declaration]
}

extension Array where Self.Element == Declaration {
    internal subscript(name: String) -> Declaration? {
        first(where: {$0.name == name})
    }
}
