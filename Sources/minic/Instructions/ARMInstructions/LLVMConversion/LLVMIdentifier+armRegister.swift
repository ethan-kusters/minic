//
//  LLVMIdentifier+armRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension LLVMIdentifier {
    var armRegister: ([ARMInstruction]?, ARMRegister)  {
        switch(self) {
        case let .virtualRegister(register):
            return (nil, register.armRegister)
        case let .globalValue(label, _):
            let destRegister = ARMRegister.virtual(.newIntRegister())
            
            let movAddr = ARMInstructionMacros.getMoveSymbol32(target: destRegister,
                                                               source: label)
            
            let loadVal = ARMInstruction.load(target: destRegister,
                                              sourceAddress: destRegister)
            
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
}
