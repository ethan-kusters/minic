//
//  ARMInstruction+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMInstruction: CustomStringConvertible {
    var description: String {
        switch(self) {
        case let .add(target, firstOp, secondOp):
            return "\tADD \(target), \(firstOp), \(secondOp)"
        case let .subtract(target, firstOp, secondOp):
            return "\tSUB \(target), \(firstOp), \(secondOp)"
        case let .multiply(target, firstOp, secondOp):
            return "\tMUL \(target), \(firstOp), \(secondOp)"
        case let .signedDivide(target, firstOp, secondOp):
            return "\tSDIV \(target), \(firstOp), \(secondOp)"
        case let .and(target, firstOp, secondOp):
            return "\tAND \(target), \(firstOp), \(secondOp)"
        case let .or(target, firstOp, secondOp):
            return "\tORR \(target), \(firstOp), \(secondOp)"
        case let .exclusiveOr(target, firstOp, secondOp):
            return "\tEOR \(target), \(firstOp), \(secondOp)"
        case let .compare(firstOp, secondOp):
            return "\tCMP \(firstOp), \(secondOp)"
        case let .branch(condCode, label):
            return "\tB\(optional: condCode) \(label)"
        case let .move(condCode, target, source):
            return "\tMOV\(optional: condCode) \(target), \(source)"
        case let .moveTop(condCode, target, source):
            return "\tMOVT\(optional: condCode) \(target), \(source)"
        case let .moveBottom(condCode, target, source):
            return "\tMOVW\(optional: condCode) \(target), \(source)"
        case let .load(target, sourceAddress, offset):
            if let offset = offset {
                return "\tLDR \(target), [\(sourceAddress), \(offset)]"
            } else {
                return "\tLDR \(target), [\(sourceAddress)]"
            }
        case let .store(source, targetAddress, offset):
            if let offset = offset {
                return "\tSTR \(source), [\(targetAddress), \(offset)]"
            } else {
                return "\tSTR \(source), [\(targetAddress)]"
            }
        case let .branchWithLink(label, _):
            return "\tBL \(label)"
        case let .push(registers):
            let registerList = registers.map(\.description).joined(separator: ", ")
            return "\tPUSH {\(registerList)}"
        case let .pop(registers):
            let registerList = registers.map(\.description).joined(separator: ", ")
            return "\tPOP {\(registerList)}"
        case let .declareGlobal(label):
            return "\t.comm \(label), \(ARMInstructionConstants.byteAlignment), \(ARMInstructionConstants.byteAlignment)"
        case let .alignmentDirective(exponent):
            return "\t.align \(exponent)"
        case let .sectionDirective(section):
            return "\t\(section)"
        case let .sizeDirective(symbol):
            return "\t.size \(symbol), .-\(symbol)"
        case let .stringDefinitionDirective(string):
            return "\t.asciz \"\(string)\""
        case let .globalSymbolDirective(symbol):
            return "\t.global \(symbol)"
        case let .architectureDirective(architecture):
            return "\t.arch \(architecture)"
        case let .label(symbol):
            return "\(symbol):"
        }
    }
    
}
