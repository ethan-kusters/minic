//
//  LatticeValue+arithmetic.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LatticeValue {
    enum ArithmeticError: Error {
        case divideByZero
    }
    
    static func +(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        return performBinaryOp(lhs: lhs, rhs: rhs) {
            $0 + $1
        }
    }
    
    static func -(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        return performBinaryOp(lhs: lhs, rhs: rhs) {
            $0 - $1
        }
    }
    
    static func /(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        return performBinaryOp(lhs: lhs, rhs: rhs) {
            guard $1 != 0 else { throw ArithmeticError.divideByZero }
            return $0 / $1
        }
    }
    
    static func *(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        return performBinaryOp(lhs: lhs, rhs: rhs) {
            $0 * $1
        }
    }
}

