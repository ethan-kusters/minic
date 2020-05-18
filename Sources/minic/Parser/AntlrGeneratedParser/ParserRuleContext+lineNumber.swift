//
//  ParserRuleContext+lineNumber.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/9/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Antlr4

extension ParserRuleContext {
    var startLineNumber: Int {
        getStart()?.getLine() ?? -1
    }
}
