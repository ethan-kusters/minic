//
//  ARMControlFlowGraph+computeGenKillSets.swift
//  minic
//
//  Created by Ethan Kusters on 5/31/20.
//

import Foundation

extension ARMControlFlowGraph {
    func computeGenKillSets(_ context: CodeGenerationContext) {
        blocks.forEach { block in
            block.computeGenKillSets(context)
        }
    }
}
