//
//  ARMControlFlowGraph+buildInterferenceGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMControlFlowGraph {
    func buildInteferenceGraph() {
        blocks.forEach { block in
            var liveNow = block.liveOutVariables
            block.instructions.reversed().forEach { instruction in
                instruction.targets.forEach { target in
                    liveNow.remove(target)
                    target.addEdges(to: liveNow)
                }
                
                liveNow.formUnion(instruction.sources)
                
                interferenceGraph.formUnion(instruction.targets)
                interferenceGraph.formUnion(instruction.sources)
            }
        }
    }
}
