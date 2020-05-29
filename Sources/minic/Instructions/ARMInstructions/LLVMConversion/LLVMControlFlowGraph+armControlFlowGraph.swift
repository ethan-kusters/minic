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
        
        parameters.forEach { parameter in
            guard let parameterIndex = parameter.parmeterIndex else { return }
            let paramVirtualReg = context.getRegister(fromVirtualRegister: parameter)
            let paramRealReg = context.getRegister(fromRealRegister: .generalPurpose(parameterIndex))
            let moveInstruction = ARMInstruction.move(condCode: nil, target: paramVirtualReg, source: .register(paramRealReg))
            armBlocks.first?.instructions.insert(moveInstruction, at: 0)
        }
        
        return ARMControlFlowGraph(withBlocks: armBlocks, forFunction: self.function, context: context)
    }
}
