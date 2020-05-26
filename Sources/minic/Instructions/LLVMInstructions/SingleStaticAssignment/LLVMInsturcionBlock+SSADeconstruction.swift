//
//  LLVMInsturcionBlock+SSADeconstruction.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension LLVMInstructionBlock {
    
    /// Removes all Phi instructions and replaces them with move instructions.
    func deconstructSSA() {
//        let copyBlock = LLVMInstructionBlock.
        
        phiInstructions.forEach { phiInstruction in
            let newPhiReg = LLVMVirtualRegister(withPrefix: "phi", type: phiInstruction.target.type)
            
            phiInstruction.operands.forEach { operand in
                let moveInstruction = LLVMInstruction.move(target: newPhiReg,
                                                           source: operand.value,
                                                           block: operand.block).logRegisterUses()
                
                operand.block.insertInstruction(moveInstruction, at: operand.block.finalBranchIndex!)
            }
            
            let moveInstruction = LLVMInstruction.move(target: phiInstruction.target,
                                                       source: .register(newPhiReg),
                                                       block: self).logRegisterUses()
            
            replaceInstruction(.phi(phiInstruction), with: moveInstruction)
        }
    }
}
