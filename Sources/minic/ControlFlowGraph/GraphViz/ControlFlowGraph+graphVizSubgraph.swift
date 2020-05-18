//
//  ControlFlowGraph+graphVizSubgraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/24/20.
//

import Foundation

extension ControlFlowGraph {
    func graphVizSubgraph(index: Int) -> String {
        var subgraph = getSubgraphHeader(index) + GraphVizConstants.openBrace
        
        subgraph += "\(GraphVizConstants.label)\"Function '\(function.name)'\"\(GraphVizConstants.semicolon)"
        blocks.forEach { block in
            subgraph += (block.label + GraphVizConstants.arrow + GraphVizConstants.openBrace)
            let successorLabels = block.successors.map(\.label)
            subgraph += successorLabels.joined(separator: GraphVizConstants.comma)
            subgraph += (GraphVizConstants.closeBrace + GraphVizConstants.semicolon)
        }
        
        subgraph += GraphVizConstants.closeBrace
        return subgraph
    }
    
    private func getSubgraphHeader(_ index: Int) -> String {
        return GraphVizConstants.subGraphHeader + " cluster_\(index) "
    }
}

