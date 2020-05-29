//
//  ARMInstruction+definedRegisters.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstruction {
    var targets: [ARMRegister] {
        switch(self) {
        case let .add(target, _, _),
             let .subtract(target, _, _),
             let .and(target, _, _),
             let .or(target, _, _),
             let .exclusiveOr(target, _, _):
            return [target]
        case let .multiply(target, _, _),
             let .signedDivide(target, _, _):
            return [target]
        case .compare(_, _):
            return []
        case .branch,
             .branchWithLink:
            return []
        case let .move(_, target, _):
            return [target]
        case let .moveTop(_, target, _),
             let .moveBottom(_, target, _):
            return [target]
        case let .load(target, _):
            return [target]
        case .store(_, _):
            return []
        case .push(_):
            return []
        case let .pop(registers):
            return registers
        case .declareGlobal,
             .alignmentDirective,
             .sectionDirective,
             .sizeDirective,
             .stringDefinitionDirective,
             .globalSymbolDirective,
             .architectureDirective,
             .label:
            return []
        }
    }
}