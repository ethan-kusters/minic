//
//  ARMControlFlowGraph+computeGenKillSets.swift
//  minic
//
//  Created by Ethan Kusters on 5/31/20.
//

import Foundation

extension ARMControlFlowGraph {
    func computeGenKillSets() {
        blocks.forEach { block in
            block.resetGenKillSets()
            block.computeGenKillSets(context)
        }
    }
}
