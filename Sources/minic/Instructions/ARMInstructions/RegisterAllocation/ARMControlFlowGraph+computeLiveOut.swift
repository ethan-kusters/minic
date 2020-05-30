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
            liveOutChanged = false
            for blondIndex in 0..<blocks.count {
                if blocks[blondIndex].computeLiveOut() {
                    liveOutChanged = true
                }
            }
        }
    }
}
