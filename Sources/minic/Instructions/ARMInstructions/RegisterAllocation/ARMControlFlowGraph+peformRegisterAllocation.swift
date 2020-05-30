//
//  ARMControlFlowGraph+peformRegisterAllocation.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMControlFlowGraph {
    func performRegisterAllocation() -> [ARMRealRegister] {
        var registerColoring = [Set<ARMRegister>]()
        
        let unconstrainedNodes = interferenceGraph.filter { node in
            (node.interferingRegisters.count < ARMInstructionConstants.availableRegisters.count)
                && (node.register is ARMVirtualRegister)
        }
        
        interferenceGraph.subtract(unconstrainedNodes)
        
        unconstrainedNodes.forEach { node in
            color(node, with: &registerColoring)
        }
        
        let constrainedNodes = interferenceGraph.filter { node in
            node.register is ARMVirtualRegister
        }
        
        interferenceGraph.subtract(constrainedNodes)
        let sortedConstrainedNodes = constrainedNodes.sorted(by: { $0.levelOfInterference > $1.levelOfInterference })
        
        sortedConstrainedNodes.forEach { node in
            color(node, with: &registerColoring)
        }
        
        let realRegisterNodes = interferenceGraph.sorted(by: { $0.levelOfInterference > $1.levelOfInterference })
        realRegisterNodes.forEach { node in
            color(node, with: &registerColoring)
        }
        
        var usedRegisters = realRegisterNodes.map { node in
            node.register as! ARMRealRegister
        }
        
        var availableRegisters = ARMInstructionConstants.availableRegisters.subtracting(usedRegisters).sorted()
        
        for registerColor in registerColoring {
            if let realRegister = registerColor.firstRealRegister {
                registerColor.forEach { register in
                    register.register = realRegister
                }
            } else if !availableRegisters.isEmpty {
                /// This coloring does not contain a real register, just grab the next available register
                let nextAvailableRegister = availableRegisters.removeFirst()
                registerColor.forEach { armRegister in
                    armRegister.register = nextAvailableRegister
                }
                
                usedRegisters.append(nextAvailableRegister)
            } else {
                fatalError("Haven't implmeneted spilling yet...")
            }
        }
            
        return usedRegisters
    }
    
    func color(_ register: ARMRegister, with registerColoring: inout [Set<ARMRegister>]) {
        if (register.register as? ARMVirtualRegister)?.label == "%_phi_84" {
            print("fount it")
        }
        
        let possibleColor = registerColoring.firstIndex { color in
            color.intersection(register.interferingRegisters).isEmpty && !color.containsRealRegister
        }
        
        
        if let colorIndex = possibleColor {
            print(registerColoring[colorIndex])
            registerColoring[colorIndex].insert(register)
        } else {
            registerColoring.append([register])
        }
    }
}
