//
//  ControlFlowGraph+graphVizSubgraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/24/20.
//

import Foundation

extension ControlFlowGraph {
    private static var subGraphIndex = 0
    
    var graphVizSubgraph: String {
        var subgraph = ControlFlowGraph.getSubgraphHeader() + GraphVizConstants.openBrace
        
        subgraph += "\(GraphVizConstants.label)\"Function '\(name)'\"\(GraphVizConstants.semicolon)"
        blocks.forEach { block in
            subgraph += (block.label + GraphVizConstants.arrow + GraphVizConstants.openBrace)
            let successorLabels = block.successors.map(\.label)
            subgraph += successorLabels.joined(separator: GraphVizConstants.comma)
            subgraph += (GraphVizConstants.closeBrace + GraphVizConstants.semicolon)
        }
        
        subgraph += GraphVizConstants.closeBrace
        return subgraph
    }
    
    private static func getSubgraphHeader() -> String {
        subGraphIndex += 1
        return GraphVizConstants.subGraphHeader + " cluster_\(subGraphIndex) "
    }
}

