//
//  ARMControlFlowGraph+buildInterferenceGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMControlFlowGraph {
    func buildInteferenceGraph() {
        registers.forEach { register in
            register.resetInterferingRegisters()
        }
        
        interferenceGraph.removeAll()
        
        blocks.forEach { block in
            var liveNow = block.liveOutVariables
            block.instructions.reversed().forEach { instruction in
                let instructionTargets = instruction.getTargets(context)
                let instructionSources = instruction.sources
                
                instructionTargets.forEach { target in
                    liveNow.remove(target)
                    target.addEdges(to: liveNow)
                }
                
                liveNow.formUnion(instructionSources)
                
                interferenceGraph.formUnion(instructionTargets)
                interferenceGraph.formUnion(instructionSources)
            }
        }
    }
}
