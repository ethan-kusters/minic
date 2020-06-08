//
//  ARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

class ARMRegister {
    var register: ARMRegisterProtocol
    let uuid = UUID()
    var uses = Set<ARMInstruction>()
    var definitions = Set<ARMInstruction>()
    var spilled = false
    
    var interferingRegisters = Set<ARMRegister>()
    
    var levelOfInterference: Double {
        Double(uses.count) / Double(interferingRegisters.count)
    }
    
    var flexibleOperand: ARMFlexibleOperand {
        .register(self)
    }
    
    init(_ register: ARMRegisterProtocol) {
        self.register = register
    }
    
    func addUse(_ instruction: ARMInstruction) {
        uses.insert(instruction)
    }
    
    func addDefinition(_ instruction: ARMInstruction) {
        definitions.insert(instruction)
    }
    
    func addEdges(to registers: Set<ARMRegister>) {
        registers.forEach { register in
            addEdge(to: register)
        }
    }
    
    func addEdge(to register: ARMRegister) {
        interferingRegisters.insert(register)
        register.interferingRegisters.insert(self)
    }
    
    func removeEdges() {
        interferingRegisters.forEach { register in
            register.interferingRegisters.remove(self)
        }
    }
    
    func resetInterferingRegisters() {
        interferingRegisters.removeAll()
    }
}
