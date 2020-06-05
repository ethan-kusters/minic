//
//  LatticeValue+bitwiseOperations.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LatticeValue {
    static func ^(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        return performBinaryOp(lhs: lhs, rhs: rhs) {
            $0 ^ $1
        }
    }
    
    static func |(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        return performBinaryOp(lhs: lhs, rhs: rhs) {
            $0 | $1
        }
    }
    
    static func &(lhs: LatticeValue, rhs: LatticeValue) -> LatticeValue? {
        return performBinaryOp(lhs: lhs, rhs: rhs) {
            $0 & $1
        }
    }
}
