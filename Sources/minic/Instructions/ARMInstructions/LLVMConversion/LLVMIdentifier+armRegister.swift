//
//  LLVMIdentifier+armRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension LLVMIdentifier {
    func getARMRegister(_ context: CodeGenerationContext) -> ([ARMInstruction]?, ARMRegister)  {
        switch(self) {
        case let .virtualRegister(virtualRegister):
            return (nil, context.getRegister(fromVirtualRegister: virtualRegister))
        case let .globalValue(label, _):
            let destRegister = context.newVirtualRegister()
            
            let movAddr = ARMInstructionMacros.getMoveSymbol32(context,
                                                               target: destRegister,
                                                               source: label)
            
            let loadVal = ARMInstruction.load(target: destRegister,
                                              sourceAddress: destRegister).logRegisterUses(context)
            
            return ([movAddr, [loadVal]].flatten(), destRegister)
        case .function:
            fatalError("Cannot convert `function` to `ARMRegister`.")
        case .label:
            fatalError("Cannot convert `label` to `ARMRegister`.")
        case .structureType:
            fatalError("Cannot convert `structureType` to `ARMRegister`.")
        case .null:
            fatalError("Cannot convert `null` to `ARMRegister`.")
        case .void:
            fatalError("Cannot convert `void` to `ARMRegister`.")
        }
    }
    
    func getARMRegisterForPointer(_ context: CodeGenerationContext) -> ([ARMInstruction]?, ARMRegister)  {
        switch(self) {
        case let .virtualRegister(virtualRegister):
            return (nil, context.getRegister(fromVirtualRegister: virtualRegister))
        case let .globalValue(label, _):
            let destRegister = context.newVirtualRegister()
            
            let movAddr = ARMInstructionMacros.getMoveSymbol32(context,
                                                               target: destRegister,
                                                               source: label)
            
            return (movAddr, destRegister)
        case .function:
            fatalError("Cannot convert `function` to `ARMRegister`.")
        case .label:
            fatalError("Cannot convert `label` to `ARMRegister`.")
        case .structureType:
            fatalError("Cannot convert `structureType` to `ARMRegister`.")
        case .null:
            fatalError("Cannot convert `null` to `ARMRegister`.")
        case .void:
            fatalError("Cannot convert `void` to `ARMRegister`.")
        }
    }
}
