//
//  ARMRegister+spill.swift
//  minic
//
//  Created by Ethan Kusters on 6/8/20.
//

import Foundation

extension ARMRegister {
    func spill(_ controlFlowGraph: ARMControlFlowGraph) {
        let context = controlFlowGraph.context
        
        let sp = context.getRegister(fromRealRegister: .stackPointer)
        let spillOffset = context.getNewSpillOffset()
        
        definitions.forEach { definition in
            let storeInstruction = ARMInstruction.store(source: self,
                                                        targetAddress: sp,
                                                        offset: spillOffset)
            
            controlFlowGraph.insertInstruction(storeInstruction, after: definition)
        }
        
        uses.forEach { use in
            let loadInstruction = ARMInstruction.load(target: self,
                                                      sourceAddress: sp,
                                                      offset: spillOffset).logRegisterUses(context)
            
            controlFlowGraph.insertInstruction(loadInstruction, before: use)
        }
        
        spilled = true
    }
}
