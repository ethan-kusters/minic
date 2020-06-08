//
//  ARMInstruction+logRegisterUses.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstruction {
    var registers: [ARMRegister] {
        switch(self) {
        case let .add(target, firstOp, secondOp),
             let .subtract(target, firstOp, secondOp),
             let .and(target, firstOp, secondOp),
             let .or(target, firstOp, secondOp),
             let .exclusiveOr(target, firstOp, secondOp):
            return [target, firstOp, secondOp.asRegister].compact()
        case let .multiply(target, firstOp, secondOp),
             let .signedDivide(target, firstOp, secondOp):
            return [target, firstOp, secondOp]
        case let .compare(firstOp, secondOp):
            return [firstOp, secondOp.asRegister].compact()
        case .branch:
            return []
         case let .branchWithLink(_, args):
            return args
        case let .move(_, target, source):
            return [target, source.asRegister].compact()
        case let .moveTop(_, target, _),
             let .moveBottom(_, target, _):
            return [target]
        case let .load(target, sourceAddress, _):
            return [target, sourceAddress]
         case let .store(source, targetAddress, _):
            return [source, targetAddress]
        case let .push(registers),
             let .pop(registers):
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
