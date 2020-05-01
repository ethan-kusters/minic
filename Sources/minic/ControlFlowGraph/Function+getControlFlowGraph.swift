//
//  Function+getControlFlowGraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

extension Function {
    func getControlFlowGraph(context: TypeContext) -> ControlFlowGraph {
        return ControlFlowGraph(blocks: ControlFlowGraphBuilder(self, context: context).blocks, function: self)
    }
}
