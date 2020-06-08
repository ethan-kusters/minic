//
//  ARMControlFlowGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

class ARMControlFlowGraph: ControlFlowGraph<ARMInstruction, ARMInstructionBlock> {
    let context: CodeGenerationContext
    var interferenceGraph = Set<ARMRegister>()
    
    init(withBlocks blocks: [ARMInstructionBlock], forFunction function: Function, context: CodeGenerationContext, skipRegisterAllocation: Bool) {
        self.context = context
        super.init(blocks: blocks, function: function)
        
        let calleeSavedUsedRegisters: [ARMRegister]
        
        if skipRegisterAllocation {
            calleeSavedUsedRegisters = []
        } else {
            computeGenKillSets(context)
            computeLiveOut()
            buildInteferenceGraph()
            
            let allUsedRegisters = performRegisterAllocation()
            calleeSavedUsedRegisters = Set(allUsedRegisters)
                .intersection(ARMInstructionConstants.calleeSavedRegisters)
                .sorted()
                .map { register in
                    context.getRegister(fromRealRegister: register)
                }
        }
        
        let valuesOnStack = context.maxNumOfArgsOnStack + context.numOfLocalsOnStack
        
        let functionPrologue = ARMInstructionMacros.getFunctionPrologue(context,
                                                                        registersUsed: calleeSavedUsedRegisters,
                                                                        valuesOnStack: valuesOnStack)
        
        let functionEpilogue = ARMInstructionMacros.getFunctionEpilogue(context,
                                                                        registersUsed: calleeSavedUsedRegisters,
                                                                        valuesOnStack: valuesOnStack)
        
        self.blocks.first?.instructions.insert(contentsOf: functionPrologue, at: 0)
        self.blocks.last?.instructions.append(contentsOf: functionEpilogue)
    }
    
    var instructions: [ARMInstruction] {
        [
            ARMInstructionMacros.getFunctionHeader(function.name),
            blocks.flatMap { block in
                [
                    [ARMInstruction.label(symbol: block.label)],
                    block.instructions
                ].flatten()
            },
            ARMInstructionMacros.getFunctionFooter(function.name)
        ].flatten()
    }
    
}
