//
//  ARMControlFlowGraph+peformRegisterAllocation.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMControlFlowGraph {
    func performRegisterAllocation() -> Set<ARMRealRegister> {
        var registerColoring = [Set<ARMRegister>]()
        var coloringStack = [ARMRegister]()
        
        while let unconstrainedNode = interferenceGraph.removeFirstUnconstrainedNode() {
            unconstrainedNode.removeEdges()
            coloringStack.append(unconstrainedNode)
        }
        
        let constrainedNodes = interferenceGraph.filter { node in
            node.register is ARMVirtualRegister
        }
        
        interferenceGraph.subtract(constrainedNodes)
        
        let sortedConstrainedNodes = constrainedNodes.sorted(by: {
            $0.levelOfInterference > $1.levelOfInterference
        })
        
        sortedConstrainedNodes.forEach { constrainedNode in
            constrainedNode.removeEdges()
            coloringStack.append(constrainedNode)
        }
        
        interferenceGraph.forEach { realNode in
            realNode.removeEdges()
            coloringStack.append(realNode)
        }
        
        while let currentNode = coloringStack.popLast() {
            color(currentNode, with: &registerColoring)
        }
        
        var availableRegisters = ARMInstructionConstants.availableRegisters
        var usedRegisters = Set<ARMRealRegister>()
        
        for registerColor in registerColoring where registerColor.containsRealRegister {
            let realRegister = registerColor.firstRealRegister!
            registerColor.forEach { register in
                register.register = realRegister
            }
            
            availableRegisters.removeAll(where: { $0 == realRegister })
            usedRegisters.insert(realRegister)
        }
        
        for registerColor in registerColoring where !registerColor.containsRealRegister {
                guard let nextAvailableRegister = availableRegisters.first(where: { realRegister in
                    let interference = context.getRegister(fromRealRegister: realRegister).interferingRegisters
                    return registerColor.intersection(interference).isEmpty
                }) else {
                    fatalError("Haven't implmented spilling yet")
                }
            
                registerColor.forEach { armRegister in
                    armRegister.register = nextAvailableRegister
                }
                
                usedRegisters.insert(nextAvailableRegister)
                availableRegisters.removeAll(where: { $0 == nextAvailableRegister })
        }
            
        return usedRegisters
    }
    
    func color(_ register: ARMRegister, with registerColoring: inout [Set<ARMRegister>]) {
        let possibleColor: Int?
        
        if register.register is ARMRealRegister {
            possibleColor = registerColoring.firstIndex { color in
                color.intersection(register.interferingRegisters).isEmpty && !color.containsRealRegister
            }
        } else {
            possibleColor = registerColoring.firstIndex { color in
                color.intersection(register.interferingRegisters).isEmpty && !color.containsNonAvailableRegister
            }
        }
        
        if let colorIndex = possibleColor {
            registerColoring[colorIndex].insert(register)
        } else {
            registerColoring.append([register])
        }
    }
}
