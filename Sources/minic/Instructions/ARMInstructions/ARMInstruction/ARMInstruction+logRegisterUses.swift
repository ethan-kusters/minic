//
//  ARMInstruction+logRegisterUses.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMInstruction {
    func logRegisterUses(_ context: CodeGenerationContext) -> ARMInstruction {
        switch(self) {
        case let .add(target, firstOp, secondOp),
             let .subtract(target, firstOp, secondOp),
             let .and(target, firstOp, secondOp),
             let .or(target, firstOp, secondOp),
             let .exclusiveOr(target, firstOp, secondOp):
            target.addDefinition(self)
            firstOp.addUse(self)
            secondOp.addUse(self)
        case let .multiply(target, firstOp, secondOp),
             let .signedDivide(target, firstOp, secondOp):
            target.addDefinition(self)
            firstOp.addUse(self)
            secondOp.addUse(self)
        case let .compare(firstOp, secondOp):
            firstOp.addUse(self)
            secondOp.addUse(self)
        case .branch:
            return self
         case let .branchWithLink(_, args):
            args.forEach { $0.addUse(self) }
            context.getRegisters(fromRealRegisters: ARMInstructionConstants.callerSavedRegisters).forEach {
                $0.addDefinition(self)
            }
        case let .move(_, target, source):
            target.addDefinition(self)
            source.addUse(self)
        case let .moveTop(_, target, _),
             let .moveBottom(_, target, _):
            target.addDefinition(self)
        case let .load(target, sourceAddress, _):
            target.addDefinition(self)
            sourceAddress.addUse(self)
        case let .store(source, targetAddress, _):
            source.addUse(self)
            targetAddress.addUse(self)
        case let .push(registers):
            registers.forEach {
                $0.addUse(self)
            }
        case let .pop(registers):
            registers.forEach {
                $0.addDefinition(self)
            }
        case .declareGlobal,
             .alignmentDirective,
             .sectionDirective,
             .sizeDirective,
             .stringDefinitionDirective,
             .globalSymbolDirective,
             .architectureDirective,
             .label:
            return self
        }
        
        return self
    }
}
