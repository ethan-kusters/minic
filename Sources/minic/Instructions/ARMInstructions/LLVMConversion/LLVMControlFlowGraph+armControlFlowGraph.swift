//
//  LLVMControlFlowGraph+armControlFlowGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension LLVMControlFlowGraph {
    func getARMControlFlowGraph(withContext context: CodeGenerationContext) -> ARMControlFlowGraph {
        var armBlocks = [ARMInstructionBlock]()
        
        for currentLLVMBlock in self.blocks {
            let currentARMBlock = armBlocks.getBlock(forLLVMBlock: currentLLVMBlock, withContext: context)
            
            currentLLVMBlock.predecessors.forEach { llvmPredeccesor in
                let armPredecessor = armBlocks.getBlock(forLLVMBlock: llvmPredeccesor, withContext: context)
                currentARMBlock.addPredecessor(armPredecessor)
            }
            
            currentLLVMBlock.successors.forEach { llvmSuccessor in
                let armSuccessor = armBlocks.getBlock(forLLVMBlock: llvmSuccessor, withContext: context)
                currentARMBlock.addSuccesor(armSuccessor)
            }
        }
        
        return ARMControlFlowGraph(withBlocks: armBlocks, forFunction: self.function, context: context)
    }
}
