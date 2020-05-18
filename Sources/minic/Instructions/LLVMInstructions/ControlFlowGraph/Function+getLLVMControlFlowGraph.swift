//
//  Function+getControlFlowGraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

extension Function {
    func getLLVMControlFlowGraph(context: TypeContext, useSSA: Bool) -> LLVMControlFlowGraph {
        return LLVMControlFlowGraph(self, context: context, useSSA: useSSA)
    }
}
