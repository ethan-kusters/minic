//
//  ARMInstructionBlock+liveOut.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstructionBlock {
    @discardableResult
    func computeLiveOut() -> Bool {
        let oldLiveOutVariables = liveOutVariables
        
        liveOutVariables = successors.union { successor in
            let genSet = successor.generatedVariables
            let liveOut = successor.liveOutVariables
            let killSet = successor.killedVariables
            
            
            return genSet.union(liveOut.subtracting(killSet))
        }
        
        return oldLiveOutVariables != liveOutVariables
    }
}
