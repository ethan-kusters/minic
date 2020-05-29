//
//  CodeGenerationContext.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

class CodeGenerationContext {
    private var virtualRegisterMapping = [ARMVirtualRegister : ARMRegister]()
    private var realRegisterMapping = [ARMRealRegister : ARMRegister]()
    
    func getRegister(fromVirtualRegister virtualRegister: LLVMVirtualRegister) -> ARMRegister {
//        guard virtualRegister.parmeterIndex == nil else {
//            return getParameterReg(fromVirtualRegister: virtualRegister)
//        }
        
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
    
    func getRegister(fromRealRegister realRegister: ARMRealRegister) -> ARMRegister{
        guard let register = realRegisterMapping[realRegister] else {
            let newRealRegister = ARMRegister(realRegister)
            realRegisterMapping[realRegister] = newRealRegister
            return newRealRegister
        }
        
        return register
    }
    
    func getParameterReg(fromVirtualRegister virtualRegister: LLVMVirtualRegister) -> ARMRegister {
        return getRegister(fromRealRegister: ARMRealRegister.generalPurpose(virtualRegister.parmeterIndex!))
    }
}
