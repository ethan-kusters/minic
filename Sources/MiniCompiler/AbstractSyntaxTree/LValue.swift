//
//  LValue.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

struct LValue {
    let lineNumber: Int
    let id: String
    let leftExpression: Expression?
}
