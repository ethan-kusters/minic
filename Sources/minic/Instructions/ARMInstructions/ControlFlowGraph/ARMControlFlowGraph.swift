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
    
    init(withBlocks blocks: [ARMInstructionBlock], forFunction function: Function, context: CodeGenerationContext) {
        self.context = context
        super.init(blocks: blocks, function: function)
        
        computeLiveOut()
        buildInteferenceGraph()
        let allUsedRegisters = performRegisterAllocation()
//        let calleeSavedUsedRegisters = Set(allUsedRegisters)
//            .intersection(ARMInstructionConstants.calleeSavedRegisters)
//            .sorted()
//            .map { register in
//                context.getRegister(fromRealRegister: register)
//        }
        
        let calleeSavedUsedRegisters = [ARMRegister]()
        
        blocks.forEach { block in
            block.liveOutVariables.forEach { liveOut in
                print(liveOut)
                print(liveOut.interferingRegisters)
            }
        }
        
        let functionPrologue = ARMInstructionMacros.getFunctionPrologue(context,
                                                                        registersUsed: calleeSavedUsedRegisters,
                                                                        valuesOnStack: 0)
        
        let functionEpilogue = ARMInstructionMacros.getFunctionEpilogue(context,
                                                                        registersUsed: calleeSavedUsedRegisters,
                                                                        valuesOnStack: 0)
        
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
