//
//  LLVMControlFlowGraph+armControlFlowGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension LLVMControlFlowGraph {
    var armControlFlowGraph: ARMControlFlowGraph {
        var armBlocks = [InstructionBlock<ARMInstruction>]()
        
        for currentLLVMBlock in self.blocks {
            let currentARMBlock = armBlocks.getBlock(forLLVMBlock: currentLLVMBlock)
            
            currentLLVMBlock.predecessors.forEach { llvmPredeccesor in
                let armPredecessor = armBlocks.getBlock(forLLVMBlock: llvmPredeccesor)
                currentARMBlock.addPredecessor(armPredecessor)
            }
            
            currentLLVMBlock.successors.forEach { llvmSuccessor in
                let armSuccessor = armBlocks.getBlock(forLLVMBlock: llvmSuccessor)
                currentARMBlock.addSuccesor(armSuccessor)
            }
        }
        
        return ARMControlFlowGraph(withBlocks: armBlocks, forFunction: self.function, context: self.context)
    }
}
