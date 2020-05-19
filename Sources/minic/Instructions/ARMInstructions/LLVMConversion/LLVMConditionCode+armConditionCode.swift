//
//  LLVMConditionCode+armConditionCode.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

extension LLVMConditionCode {
    var armConditionCode: ARMConditionCode {
        switch(self) {
        case .eq:
            return .EQ
        case .ne:
            return .NE
        case .ugt:
            return .HI
        case .uge:
            return .HS
        case .ult:
            return .LO
        case .ule:
            return .LS
        case .sgt:
            return .GT
        case .sge:
            return .GE
        case .slt:
            return .LT
        case .sle:
            return .LE
        }
    }
}
