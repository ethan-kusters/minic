//
//  LLVMControlFlowGraph+armControlFlowGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension LLVMControlFlowGraph {
    func getARMControlFlowGraph(skipRegisterAllocation: Bool) -> ARMControlFlowGraph {
        let context = CodeGenerationContext(forFunction: function)
        
        deconstructSSA()
        
        var armBlocks = [ARMInstructionBlock]()
        var tempARMBlocks = [ARMInstructionBlock]()
        
        for currentLLVMBlock in self.blocks {
            let currentARMBlock = tempARMBlocks.getBlock(forLLVMBlock: currentLLVMBlock, withContext: context)
            
            currentLLVMBlock.predecessors.forEach { llvmPredeccesor in
                let armPredecessor = tempARMBlocks.getBlock(forLLVMBlock: llvmPredeccesor, withContext: context)
                currentARMBlock.addPredecessor(armPredecessor)
            }
            
            currentLLVMBlock.successors.forEach { llvmSuccessor in
                let armSuccessor = tempARMBlocks.getBlock(forLLVMBlock: llvmSuccessor, withContext: context)
                currentARMBlock.addSuccesor(armSuccessor)
            }
            
            armBlocks.append(currentARMBlock)
        }
        
        parameters.forEach { parameter in
            guard let parameterIndex = parameter.parameterIndex else { return }
            let paramVirtualReg = context.getRegister(fromVirtualRegister: parameter)
            
            if parameterIndex < 4 {
                let paramRealReg = context.getRegister(fromRealRegister: .generalPurpose(parameterIndex))
                let moveInstruction = ARMInstruction.move(condCode: nil,
                                                          target: paramVirtualReg,
                                                          source: .register(paramRealReg)).logRegisterUses(context)
                armBlocks.first?.instructions.insert(moveInstruction, at: 0)
            } else {
                let fp = context.getRegister(fromRealRegister: .framePointer)
                let offset = (parameterIndex - 3) * ARMInstructionConstants.bytesPerValue
                
                let loadInstruction = ARMInstruction.load(target: paramVirtualReg,
                                                          sourceAddress: fp,
                                                          offset: offset.immediateValue).logRegisterUses(context)
                
                armBlocks.first?.instructions.insert(loadInstruction, at: 0)
            }
        }
        
        return ARMControlFlowGraph(withBlocks: armBlocks,
                                   forFunction: self.function,
                                   context: context,
                                   skipRegisterAllocation: skipRegisterAllocation)
    }
}
