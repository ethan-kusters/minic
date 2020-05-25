//
//  LLVMIdentifier+armLabel.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension LLVMIdentifier {
    var armSymbol: ARMSymbol {
        switch(self) {
        case let .function(funcLabel, _):
            return funcLabel
        case let .label(label):
            return label
        case let .globalValue(label, _):
            return label
        case .virtualRegister:
            fatalError("Cannot convert `virtualRegister` to `ARMLabel`.")
        case .structureType:
            fatalError("Cannot convert `structureType` to `ARMLabel`.")
        case .null:
            fatalError("Cannot convert `null` to `ARMLabel`.")
        case .void:
            fatalError("Cannot convert `void` to `ARMLabel`.")
        }
    }
}
