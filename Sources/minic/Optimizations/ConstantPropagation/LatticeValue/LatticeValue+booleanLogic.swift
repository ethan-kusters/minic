//
//  LatticeValue+booleanLogic.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LatticeValue {
    
    static func &&(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        switch (lhs, rhs) {
        case let (_, .constant(value)) where value == LLVMInstructionConstants.falseValue:
            return .constant(value)
        case let (.constant(value), _) where value == LLVMInstructionConstants.falseValue:
            return .constant(value)
        case let (.constant(lhsValue), .constant(rhsValue)):
            let lhsBoolValue = lhsValue == LLVMInstructionConstants.trueValue ? true : false
            let rhsBoolValue = rhsValue == LLVMInstructionConstants.trueValue ? true : false
            
            let resultBoolValue = lhsBoolValue && rhsBoolValue
            
            let resultValue = resultBoolValue == true ? LLVMInstructionConstants.trueValue : LLVMInstructionConstants.falseValue
            
            return .constant(resultValue)
        case (.bottom, _),
             (_, .bottom):
            return .bottom
        default:
            return nil
        }
    }
    
    static func ||(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        switch (lhs, rhs) {
        case let (_, .constant(value)) where value == LLVMInstructionConstants.trueValue:
            return .constant(value)
        case let (.constant(value), _) where value == LLVMInstructionConstants.trueValue:
            return .constant(value)
        case let (.constant(lhsValue), .constant(rhsValue)):
            let lhsBoolValue = lhsValue == LLVMInstructionConstants.trueValue ? true : false
            let rhsBoolValue = rhsValue == LLVMInstructionConstants.trueValue ? true : false
            
            let resultBoolValue = lhsBoolValue || rhsBoolValue
            
            let resultValue = resultBoolValue == true ? LLVMInstructionConstants.trueValue : LLVMInstructionConstants.falseValue
            
            return .constant(resultValue)
        case (.bottom, _),
             (_, .bottom):
            return .bottom
        default:
            return nil
        }
    }
    
    static func ==(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        performBinaryOp(lhs: lhs, rhs: rhs) {
            if $0 == $1 {
                return LLVMInstructionConstants.trueValue
            } else {
                return LLVMInstructionConstants.falseValue
            }
        }
    }
    
    static func !=(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        performBinaryOp(lhs: lhs, rhs: rhs) {
            if $0 != $1 {
                return LLVMInstructionConstants.trueValue
            } else {
                return LLVMInstructionConstants.falseValue
            }
        }
    }
    
    static func >(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        performBinaryOp(lhs: lhs, rhs: rhs) {
            if $0 > $1 {
                return LLVMInstructionConstants.trueValue
            } else {
                return LLVMInstructionConstants.falseValue
            }
        }
    }
    
    static func >=(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        performBinaryOp(lhs: lhs, rhs: rhs) {
            if $0 >= $1 {
                return LLVMInstructionConstants.trueValue
            } else {
                return LLVMInstructionConstants.falseValue
            }
        }
    }
    
    static func <(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        performBinaryOp(lhs: lhs, rhs: rhs) {
            if $0 < $1 {
                return LLVMInstructionConstants.trueValue
            } else {
                return LLVMInstructionConstants.falseValue
            }
        }
    }
    
    static func <=(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        performBinaryOp(lhs: lhs, rhs: rhs) {
            if $0 <= $1 {
                return LLVMInstructionConstants.trueValue
            } else {
                return LLVMInstructionConstants.falseValue
            }
        }
    }
    
}
