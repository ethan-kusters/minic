//
//  ControlFlowGraph+sparseConditionalConstantPropagation.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMControlFlowGraph {
    func sparseConditionalConstantPropagation() {
        var flowWorkList = [GraphEdge]()
        var ssaWorkList = [LLVMVirtualRegister]()
        
        var registerValues = LatticeMapping()
        
        virtualRegisters.forEach { register in
            guard register.parameterIndex == nil else {
                registerValues[register] = .bottom
                return
            }
            
            registerValues[register] = .top
        }
        
        guard let entryBlock = entryBlock else { fatalError() }
        let programEntranceBlock = LLVMInstructionBlock("_ProgramEntrance")
        flowWorkList.append(GraphEdge(from: programEntranceBlock,
                                      to: entryBlock))
        
        entryBlock.addPredecessor(programEntranceBlock)
        
        while !flowWorkList.isEmpty || !ssaWorkList.isEmpty {
            while !flowWorkList.isEmpty  {
                let currentEdge = flowWorkList.removeFirst()
                guard currentEdge.executable == false else { continue }
                currentEdge.makeExecutable()
                
                let destination = currentEdge.destination
                
                if !destination.visitedDuringConstantPropagation {
                    destination.instructions.forEach { $0.evaluateWithLattice(&registerValues,
                                                                              ssaWorkList: &ssaWorkList,
                                                                              flowWorkList: &flowWorkList) }
                    
                    destination.visitedDuringConstantPropagation = true
                } else {
                    destination.phiInstructions.forEach { phiInstruction in
                        let instruction = LLVMInstruction.phi(phiInstruction)
                        instruction.evaluateWithLattice(&registerValues,
                                                        ssaWorkList: &ssaWorkList,
                                                        flowWorkList: &flowWorkList)
                    }
                }
                
            }
            
            while !ssaWorkList.isEmpty {
                let currentRegister = ssaWorkList.removeFirst()
                currentRegister.uses.forEach { use in
                    if use.block.executable {
                        use.block.instructions.forEach { $0.evaluateWithLattice(&registerValues,
                                                                                ssaWorkList: &ssaWorkList,
                                                                                flowWorkList: &flowWorkList) }
                    } else if case .phi = use {
                        use.evaluateWithLattice(&registerValues,
                                                ssaWorkList: &ssaWorkList,
                                                flowWorkList: &flowWorkList)
                    }
                }
            }
        }
        
        registerValues.forEach { (key, value) in
            guard case let .constant(value) = value else { return }
            key.replaceAllUses(withValue: .literal(value))
        }
        
        
        let conditionalBranchInstructions = blocks.flatMap { block in
            block.conditionalBranchInstructions
        }
        
        conditionalBranchInstructions.forEach { branchInstruction in
            guard case let .conditionalBranch(_, ifTrue, ifFalse, block) = branchInstruction else { return }
            
            if !ifTrue.incomingEdgeIsExecutable[block]! && !ifFalse.incomingEdgeIsExecutable[block]! {
                block.removeInstruction(branchInstruction)
            } else if !ifTrue.incomingEdgeIsExecutable[block]! {
                block.replaceInstruction(branchInstruction, with: .unconditionalBranch(ifFalse, block: block))
            } else if !ifFalse.incomingEdgeIsExecutable[block]! {
                block.replaceInstruction(branchInstruction, with: .unconditionalBranch(ifTrue, block: block))
            }
        }
        
        let phiInstructions = blocks.flatMap { block in
            block.phiInstructions
        }
        
        phiInstructions.forEach { phiInstruction in
            phiInstruction.operands = phiInstruction.operands.filter { operand in
                operand.block.executable
            }
        }
        
        blocks.removeAll { block in
            block.executable == false
        }
        
        blocks.removeTrivialPhis()
    }
}
