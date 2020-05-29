//
//  ARMControlFlowGraph+peformRegisterAllocation.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMControlFlowGraph {
    func performRegisterAllocation() -> [ARMRealRegister] {
        let numberOfColors = 10
        var registerColoring = [Set<ARMRegister>]()
        
        let unconstrainedNodes = interferenceGraph.filter { node in
            (node.interferingRegisters.count < numberOfColors) && (node.register is ARMVirtualRegister)
        }
        
        interferenceGraph.subtract(unconstrainedNodes)
        
        unconstrainedNodes.forEach { node in
            color(node, with: &registerColoring)
        }
        
        let constrainedNodes = interferenceGraph.filter { node in
            node.register is ARMVirtualRegister
        }
        
        interferenceGraph.subtract(constrainedNodes)
        let sortedConstrainedNodes = constrainedNodes.sorted(by: {$0.levelOfInterference > $1.levelOfInterference})
        
        sortedConstrainedNodes.forEach { node in
            color(node, with: &registerColoring)
        }
        
        var usedRegisters = interferenceGraph.map { node in
            node.register as! ARMRealRegister
        }
        
        for regIndex in 4...11 {
            guard !registerColoring.isEmpty else { return usedRegisters }
            guard !usedRegisters.containsRegisterIndex(regIndex) else { continue }
            let current = registerColoring.removeFirst()
            current.forEach { register in
                register.register = ARMRealRegister.generalPurpose(regIndex)
            }
            
            usedRegisters.append(ARMRealRegister.generalPurpose(regIndex))
        }
        
        return usedRegisters
    }
    
    func color(_ register: ARMRegister, with registerColoring: inout [Set<ARMRegister>]) {
        let possibleColor = registerColoring.firstIndex { color in
            color.intersection(register.interferingRegisters).isEmpty
        }
        
        if let color = possibleColor {
            registerColoring[color].insert(register)
        } else {
            registerColoring.append([register])
        }
    }
}
