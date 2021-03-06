//
//  LatticeValue+performBinaryOp.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LatticeValue {
    static func performBinaryOp(lhs: LatticeValue, rhs: LatticeValue,
                                            op: (Int, Int) throws -> (Int)) -> LatticeValue? {
        switch(lhs, rhs) {
        case let (.constant(lhsValue), constant(rhsValue)):
            do {
                let constantVal = try op(lhsValue, rhsValue)
                return .constant(constantVal)
            } catch {
                /// Probably a divide by zero error
                return .bottom
            }
        case (_, .bottom),
             (.bottom, _):
            return .bottom
        default:
            return nil
        }
    }
}
