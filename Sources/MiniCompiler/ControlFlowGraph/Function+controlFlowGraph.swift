//
//  Function+controlFlowGraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

extension Function {
    var controlFlowGraph: ControlFlowGraph {
        return ControlFlowGraph(blocks: ControlFlowGraphBuilder(self).blocks, name: name)
    }
}
