//
//  ARMControlFlowGraph+computeLiveOut.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMControlFlowGraph {
    func computeLiveOut() {
        var liveOutChanged = true
        
        while liveOutChanged {
            liveOutChanged = blocks.map { block in
                block.computeLiveOut()
            }.contains(true)
        }
    }
}
