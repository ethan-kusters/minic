//
//  ARMInstruction+usedRegisters.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstruction {
    var sources: [ARMRegister] {
        switch(self) {
        case let .add(_, firstOp, secondOp),
             let .subtract(_, firstOp, secondOp),
             let .and(_, firstOp, secondOp),
             let .or(_, firstOp, secondOp),
             let .exclusiveOr(_, firstOp, secondOp):
            if case let .register(secondOpReg) = secondOp {
                return [firstOp, secondOpReg]
            } else {
                return [firstOp]
            }
        case let .multiply(_, firstOp, secondOp),
             let .signedDivide(_, firstOp, secondOp):
            return [firstOp, secondOp]
        case let .compare(firstOp, secondOp):
            if case let .register(secondOpReg) = secondOp {
                return [firstOp, secondOpReg]
            } else {
                return [firstOp]
            }
        case .branch:
            return []
        case let .branchWithLink(_, arguments):
            return arguments
        case let .move(condCode, target, source):
            if case let .register(sourceReg) = source {
                guard condCode == nil else {
                    return [target, sourceReg]
                }
                
                return [sourceReg]
            } else {
                guard condCode == nil else {
                    return [target]
                }
                
                return []
            }
        case .moveTop(_, _, _),
             .moveBottom(_, _, _):
            return []
        case let .load(_, sourceAddress, _):
            return [sourceAddress]
        case let .store(source, targetAddress, _):
            return [source, targetAddress]
        case let .push(registers):
            return registers
        case .pop(_):
            return []
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
