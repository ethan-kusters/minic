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
            return "ADD \(target), \(firstOp), \(secondOp)"
        case let .subtract(target, firstOp, secondOp):
            return "SUB \(target), \(firstOp), \(secondOp)"
        case let .multiply(target, firstOp, secondOp):
            return "MUL \(target), \(firstOp), \(secondOp)"
        case let .signedDivide(target, firstOp, secondOp):
            return "SDIV \(target), \(firstOp), \(secondOp)"
        case let .and(target, firstOp, secondOp):
            return "AND \(target), \(firstOp), \(secondOp)"
        case let .or(target, firstOp, secondOp):
            return "ORR \(target), \(firstOp), \(secondOp)"
        case let .exclusiveOr(target, firstOp, secondOp):
            return "EOR \(target), \(firstOp), \(secondOp)"
        case let .compare(firstOp, secondOp):
            return "CMP \(firstOp), \(secondOp)"
        case let .branch(condCode, label):
            return "B\(optional: condCode) \(label)"
        case let .move(condCode, target, source):
            return "MOV\(optional: condCode) \(target), \(source)"
        case let .moveTop(condCode, target, source):
            return "MOVT\(optional: condCode) \(target), \(source)"
        case let .moveBottom(condCode, target, source):
            return "MOVW\(optional: condCode) \(target), \(source)"
        case let .load(target, sourceAddress):
            return "LDR \(target), \(sourceAddress)"
        case let .store(source, targetAddress):
            return "STR \(source), \(targetAddress)"
        case let .branchWithLink(label):
            return "BL \(label)"
        case let .push(registers):
            let registerList = registers.map(\.description).joined(separator: ", ")
            return "PUSH {\(registerList)}"
        case let .pop(registers):
            let registerList = registers.map(\.description).joined(separator: ", ")
            return "POP {\(registerList)}"
        case let .declareGlobal(label):
            return ".comm \(label), 4"
        }
    }
    
}
