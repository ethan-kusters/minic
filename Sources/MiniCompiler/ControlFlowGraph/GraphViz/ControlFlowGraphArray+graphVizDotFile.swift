//
//  ControlFlowGraphArray+graphVizDotFile.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/25/20.
//

import Foundation

extension Array where Element == ControlFlowGraph {
    var graphVizDotFile: String {
        var dotfile = GraphVizConstants.dotfileHeader + GraphVizConstants.openBrace
        
        forEach { controlFlowGraph in
            dotfile += controlFlowGraph.graphVizSubgraph
        }
        
        dotfile += GraphVizConstants.closeBrace
        return dotfile
    }
}
