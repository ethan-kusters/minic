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
            let movBot = ARMInstruction.moveBottom(condCode: nil,
                                                    target: destRegister,
                                                    source: .symbol(prefix: .lower16,
                                                                    symbol: label))
            
            let movTop = ARMInstruction.moveTop(condCode: nil,
                                                 target: destRegister,
                                                 source: .symbol(prefix: .upper16,
                                                                 symbol: label))
            
            return ([movBot, movTop], destRegister)
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
