//
//  LLVMInstruction+evaluateWithLattice.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMInstruction {
    func evaluateWithLattice(_ mapping: inout LatticeMapping,
                             ssaWorkList: inout [LLVMVirtualRegister],
                             flowWorkList: inout [GraphEdge]) {
        switch(self) {
        case let .add(target, firstOp, secondOp, _):
            guard let newResult = firstOp.getLatticeValue(mapping) + secondOp.getLatticeValue(mapping) else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .subtract(target, firstOp, secondOp, _):
            guard let newResult = firstOp.getLatticeValue(mapping) - secondOp.getLatticeValue(mapping) else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .multiply(target, firstOp, secondOp, _):
            guard let newResult = firstOp.getLatticeValue(mapping) * secondOp.getLatticeValue(mapping) else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .signedDivide(target, firstOp, secondOp, _):
            guard let newResult = firstOp.getLatticeValue(mapping) / secondOp.getLatticeValue(mapping) else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .and(target, firstOp, secondOp, _):
            guard let newResult = firstOp.getLatticeValue(mapping) && secondOp.getLatticeValue(mapping) else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .or(target, firstOp, secondOp, _):
            guard let newResult = firstOp.getLatticeValue(mapping) || secondOp.getLatticeValue(mapping) else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .exclusiveOr(target, firstOp, secondOp, _):
            guard let newResult = firstOp.getLatticeValue(mapping) ^ secondOp.getLatticeValue(mapping) else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .comparison(target, condCode, firstOp, secondOp, _):
            let cmpResult: LatticeValue?
            let lhsValue = firstOp.getLatticeValue(mapping)
            let rhsValue = secondOp.getLatticeValue(mapping)
            
            switch(condCode) {
            case .eq:
                cmpResult = (lhsValue == rhsValue)
            case .ne:
                cmpResult = (lhsValue != rhsValue)
            case .sgt:
                cmpResult = (lhsValue > rhsValue)
            case .sge:
                cmpResult = (lhsValue >= rhsValue)
            case .slt:
                cmpResult = (lhsValue < rhsValue)
            case .sle:
                cmpResult = (lhsValue <= rhsValue)
            }
            
            guard let newResult = cmpResult else { return }
            mapping.setValue(&ssaWorkList, for: target, with: newResult)
        case let .conditionalBranch(conditional, ifTrue, ifFalse, block):
            switch conditional.getLatticeValue(mapping) {
            case let .constant(value) where value == LLVMInstructionConstants.trueValue:
                flowWorkList.append(GraphEdge(from: block, to: ifTrue))
            case let .constant(value) where value == LLVMInstructionConstants.falseValue:
                flowWorkList.append(GraphEdge(from: block, to: ifFalse))
            case .bottom:
                flowWorkList.append(GraphEdge(from: block, to: ifFalse))
                flowWorkList.append(GraphEdge(from: block, to: ifTrue))
            default:
                return
            }
        case let .unconditionalBranch(targetBlock, block):
            flowWorkList.append(GraphEdge(from: block, to: targetBlock))
        case let .phi(phiInstruction):
            let possibleValues = phiInstruction.operands.filter(\.block.executable).map { operand in
                operand.value.getLatticeValue(mapping)
            }
            
            mapping.setValue(&ssaWorkList, for: phiInstruction.target, with: possibleValues.meet())
        case let .load(target, _, _):
            mapping.setValue(&ssaWorkList, for: target, with: .bottom)
        case .store:
            return
        case let .getElementPointer(target, _, _, _, _):
            mapping.setValue(&ssaWorkList, for: target, with: .bottom)
        case let .call(target, _, _, _):
            if let target = target {
                mapping.setValue(&ssaWorkList, for: target, with: .bottom)
            }
        case .returnValue, .returnVoid:
            return
        case let .allocate(target, _):
            mapping.setValue(&ssaWorkList, for: target, with: .bottom)
        case .declareGlobal, .declareStructureType:
            return
        case let .bitcast(target, source, _),
             let .truncate(target, source, _),
             let .zeroExtend(target, source, _):
            mapping.setValue(&ssaWorkList, for: target, with: source.getLatticeValue(mapping))
        case .print, .println:
            return
        case let .read(target, _):
            mapping.setValue(&ssaWorkList, for: target, with: .bottom)
        case .move:
            return
        }
    }
}
