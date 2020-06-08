//
//  CodeGenerationContext.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

class CodeGenerationContext {
    private let function: Function
    
    private var virtualRegisterMapping = [ARMVirtualRegister : ARMRegister]()
    private var realRegisterMapping = [ARMRealRegister : ARMRegister]()
    private(set) var localValueMapping = [LLVMIdentifier : ARMImmediateValue]()
    
    private(set) var maxNumOfArgsOnStack = 0
    private(set) var numOfLocalsOnStack = 0
    
    init(forFunction function: Function) {
        self.function = function
    }
    
    func getRegister(fromVirtualRegister virtualRegister: LLVMVirtualRegister) -> ARMRegister {
        let armVirtualRegister = ARMVirtualRegister(virtualRegister.description)
        
        guard let register = virtualRegisterMapping[armVirtualRegister] else {
            let newVirtualRegister = ARMRegister(armVirtualRegister)
            virtualRegisterMapping[armVirtualRegister] = newVirtualRegister
            return newVirtualRegister
        }
        
        return register
    }
    
    func newVirtualRegister() -> ARMRegister {
        let registerLabel = LLVMVirtualRegister(ofType: .null).description
        let newVirtualRegister = ARMVirtualRegister(registerLabel)
        let newRegister = ARMRegister(newVirtualRegister)
        
        virtualRegisterMapping[newVirtualRegister] = newRegister
        return newRegister
    }
    
    func getRegister(fromRealRegister realRegister: ARMRealRegister) -> ARMRegister {
        guard let register = realRegisterMapping[realRegister] else {
            let newRealRegister = ARMRegister(realRegister)
            realRegisterMapping[realRegister] = newRealRegister
            return newRealRegister
        }
        
        return register
    }
    
    func getRegisters(fromRealRegisters registers: Set<ARMRealRegister>) -> [ARMRegister] {
        registers.map { register in
            getRegister(fromRealRegister: register)
        }
    }
    
    func setMaxNumOfArgsOnStack(_ numOfArgs: Int) {
        guard numOfArgs > maxNumOfArgsOnStack else { return }
        maxNumOfArgsOnStack = numOfArgs
    }
    
    func mapLocalAllocation(_ id: LLVMIdentifier) {
        let offset = ((numOfLocalsOnStack) * ARMInstructionConstants.bytesPerValue)
        numOfLocalsOnStack += 1
        
        localValueMapping[id] = offset.immediateValue
    }
}
