//
//  Function+constructControlFlowGraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

extension Function {
    func constructControlFlowGraph() -> [Block] {
        return ControlFlowGraphBuilder(self).blocks
    }
}
